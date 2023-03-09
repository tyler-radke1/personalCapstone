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
    
    override func didMove(to view: SKView) {
        guard let player = player else { return }
        super.didMove(to: view)
        self.roomType = configureRoomType()
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
            switch type as? String {
            case "right":
                player.positionToMoveTo = CGPoint(x: -700, y: player.position.y)
                generateRoom(roomsToCheckFor: Quest.roomsExitLeft)
            case "left":
                player.positionToMoveTo = CGPoint(x: 3400, y: player.position.y)
                generateRoom(roomsToCheckFor: Quest.roomsExitRight)
            case "top":
                player.positionToMoveTo = CGPoint(x: player.position.x, y: -500)
                generateRoom(roomsToCheckFor: Quest.roomsExitDown)
            case "bottom":
                player.positionToMoveTo = CGPoint(x: player.position.x, y: 1700)
                generateRoom(roomsToCheckFor: Quest.roomsExitUp)
            default:
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
        
        let potentialEdges = player.currentQuest?.edges(from: player.currentRoom!)
        //Loops through edges, and if it finds an existing edge in the direction, brings it up
        //Otherwise, generates a new random room and edge
        for edge in potentialEdges! {
            if roomsToCheckFor.contains(edge.destination.data) {
                player.currentRoom = edge.destination
                self.presentNewScene(player: player, ofFileName: edge.destination.data.name!, andType: RoomScene())
                return
            }
        }
        
        if let randomRoom = roomsToCheckFor.randomElement() {
            
            let newVertex = player.currentQuest?.createVertex(data: randomRoom!)
            player.currentQuest?.addUndirectedEdge(between: newVertex!, and: player.currentRoom!)
            player.currentRoom = newVertex
            self.presentNewScene(player: player, ofFileName: (newVertex?.data.name)!, andType: RoomScene())
        }
    }
}

