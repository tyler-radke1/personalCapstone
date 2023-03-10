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
        configureRoomType()
        // print("\(self.roomType!), \(self.name)")
        player?.currentRoom?.addEnemies(scene: self)
        print(player?.currentQuest)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if playerCollidesWith(type: ExitNode()) {
            configureRoomExit()
        }
        
        if playerCollidesWith(type: EnemyNode()) {
            configureEnemy()
        }
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
                player.positionToMoveTo = CGPoint(x: -700, y: player.position.y)
                generateRoom(roomsToCheckFor: quest.roomsExitLeft)
            case "left":
                player.positionToMoveTo = CGPoint(x: 3400, y: player.position.y)
                generateRoom(roomsToCheckFor: quest.roomsExitRight)
            case "top":
                player.positionToMoveTo = CGPoint(x: player.position.x, y: -500)
                generateRoom(roomsToCheckFor: quest.roomsExitDown)
            case "bottom":
                player.positionToMoveTo = CGPoint(x: player.position.x, y: 1700)
                generateRoom(roomsToCheckFor: quest.roomsExitUp)
            default:
                fatalError()
                print("oof")
            }
        }
    }
    
    func configureEnemy() {
        guard let player = player else { return }
        
        let enemies = self.children.filter({ $0 is EnemyNode })
        
        for enemy in enemies {
            guard player.intersects(enemy) else { continue }
            EnemyNode.enemyForBattle = enemy as! EnemyNode
            self.player?.prepareForScene()
            PlayerNode.player.positionToMoveTo = player.position
            self.presentNewScene(player: player, ofFileName: "Battle", andType: BattleScene())
        }
        
    }
    
    func generateRoom(roomsToCheckFor: [RoomScene?]) {
        guard let player = player else { return }
        
        var allRooms: [Vertex<RoomScene>] = []
        player.currentQuest?.adjacencies.keys.forEach({ allRooms.append($0)})
        
        let potentialEdges = player.currentQuest?.edges(from: player.currentRoom!)
        //Loops through edges, and if it finds an existing edge in the direction, brings it up
        //Otherwise, generates a new random room and edge
        //  print(potentialEdges)
        guard let potentialEdges = potentialEdges else {
            return
        }
        let edge = potentialEdges.first { edge in
            roomsToCheckFor.contains(edge.destination.data)
        }
        
        self.presentNewRoom(player: player, scene: (edge?.destination.data)!)
        
//        let roomNames = roomsToCheckFor.map { $0?.name }
//        for room in allRooms {
//            for edge in potentialEdges {
//                if (edge.destination.data == room.data) {
//                    self.player?.currentRoom = room
//                    self.presentNewRoom(player: player, scene: room.data)
//                    return
//                }
//            }
//        }
//
//        if let randomRoom = roomsToCheckFor.randomElement() {
//            let newVertex = player.currentQuest?.createVertex(data: randomRoom!)
//            //   newVertex?.generateEnemies(player: player)
//            player.currentQuest?.addUndirectedEdge(between: player.currentRoom!, and: newVertex!)
//            player.previousRoom = player.currentRoom
//            player.currentRoom = newVertex
//            self.presentNewRoom(player: player, scene: newVertex!.data)
//        }
    }
}

