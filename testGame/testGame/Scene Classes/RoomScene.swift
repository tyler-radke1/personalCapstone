//
//  DesertQuest.swift
//  testGame
//
//  Created by Tyler Radke on 2/26/23.
//


import UIKit
import SpriteKit
enum RoomType {
    case upperLeft
    case forkDown
    case upperRight
    case lowerLeft
    case forkUp
    case lowerRight
}

class RoomScene: GameScene {
    var roomType: RoomType? = nil
    var Id = UUID()
    override func didMove(to view: SKView) {
        super.didMove(to: view)
       
    }
    
    override func sceneDidLoad() {
        print("scene Loaded - \(self.name)")
        configureRoomType()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.player?.position = CGPoint(x: 0, y: 0)
        cameraNode.configureCamera(around: self.player!)
        print(player!.position)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if playerCollidesWith(type: ExitNode()) {
            configureRoomExit()
        }
        
        if playerCollidesWith(type: EnemyNode()) {
            configureEnemy()
        }
        configureButtons()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Location - \(touches.first!.location(in: self))")
        print("camera - \(cameraNode.position)")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    func configureRoomType() -> RoomType {
        if let player = self.player {
            
            switch player.currentRoom?.data.name {
            case "Room1":
                return .upperLeft
            case "Room2":
                return .forkDown
            case "Room3":
                return .upperRight
            case "Room4":
                return .lowerLeft
            case "Room5":
                return .forkUp
            case "Room6":
                return .lowerRight
            default:
                return .upperLeft
            }
        }
        return .upperLeft
    }
    
    func configureRoomExit() {
        guard let player = player else { return }
        
        let roomExits = self.children.filter { $0 is ExitNode }
        for roomExit in roomExits {
            guard player.intersects(roomExit) else { continue }
            let type = roomExit.userData?["exitType"]
            let quest = Quest()
            switch type as? String {
            case "right":
               // player.positionToMoveTo = CGPoint(x: -700, y: player.position.y)
                generateRoom(roomsToCheckFor: quest.roomsExitLeft)
                return
            case "left":
              //  player.positionToMoveTo = CGPoint(x: 3400, y: player.position.y)
                generateRoom(roomsToCheckFor: quest.roomsExitRight)
                return
            case "top":
             //   player.positionToMoveTo = CGPoint(x: player.position.x, y: -500)
                generateRoom(roomsToCheckFor: quest.roomsExitDown)
                return
            case "bottom":
              //  player.positionToMoveTo = CGPoint(x: player.position.x, y: 1700)
                generateRoom(roomsToCheckFor: quest.roomsExitUp)
                return
            default:
                fatalError()
                print("oof")
            }
            return
        }
    }
    
    func configureEnemy() {
        guard let player = player else { return }
        
        let enemies = self.children.filter({ $0 is EnemyNode })
        
        for enemy in enemies {
            guard player.intersects(enemy) else { continue }
            EnemyNode.enemyForBattle = enemy as! EnemyNode
            self.player?.prepareForScene()
           // PlayerNode.player.positionToMoveTo = player.position
            self.presentNewScene(player: player, ofFileName: "Battle", andType: BattleScene())
        }
        
    }
    
//    func generateRoom(roomsToCheckFor: [RoomScene?]) {
//
//
//        for potentialEdge in potentialEdges {
//            if roomsAsNames.contains(potentialEdge.destination.data.name) {
//                edge = potentialEdge
//                break
//            }
//        }
//    let edge = potentialEdges.first { edge in
//        print(roomsAsNames.contains(edge.destination.data.name))
//       return roomsAsNames.contains(edge.destination.data.name)
//
//    }
//
//        if let edge {
//            print("about to present")
//            self.presentNewRoom(player: player, scene: (edge.destination.data))
//        } else {
//            print("hit")
//        }
//    }
    
    func generateRoom(roomsToCheckFor: [RoomScene?]) {
        guard let player = player, let currentRoom = player.currentRoom else { return }
              let roomsAsNames = roomsToCheckFor.map { $0?.name }
              let potentialEdges = player.currentQuest?.edges(from: currentRoom)
              guard let potentialEdges = potentialEdges else {
                  return
              }
      
            var potentialRooms: [RoomScene] = potentialEdges.map({ $0.destination.data })
            var edge: Edge<RoomScene>? = nil
        
        for room in potentialRooms {
            if roomsToCheckFor.contains(room) {
                presentNewRoom(player: player, scene: room)
            }
        }
            print(potentialEdges.count)
            let newRoom = roomsToCheckFor.randomElement()
            
    }
    
    func presentNewRoom(player: PlayerNode, scene: RoomScene) {
        //scene.player = player
        scene.scaleMode = .aspectFit
        player.prepareForScene()
        EnemyNode.enemyForBattle.prepareToChangeScene()
        
        for child in self.children {
            if child is EnemyNode {
                child.removeFromParent()
            }
        }
        
        self.scene?.view?.presentScene(scene)
        
    }
}
