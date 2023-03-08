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
        super.didMove(to: view)
        player.inputView?.bringSubviewToFront(view)
        EnemyNode.generateEnemies(player: player)
        self.roomType = configureRoomType()
        print(player.currentQuest?.description)
        
        for child in self.children {
            if child is ExitNode {
                print(child.userData)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if playerCollidesWith(type: ExitNode()) {
            configureRoomExit()
        }
    }
    
    func configureRoomType() -> RoomType {
        switch self.player.currentRoom?.data.name {
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
    
    func configureRoomExit() {
        guard let currentRoom = player.currentRoom else { return }
        
        
        let roomExits = self.children.filter { $0 is ExitNode }
        
        
        
        for roomExit in roomExits {
            guard player.intersects(roomExit) else { return }
            let type = roomExit.userData?["exitType"]
            switch type as? String {
            case "right":
                goRight()
            case "left":
                print("go left")
            case "top":
                print("go up")
            case "bottom":
                print("go down")
            default:
                print("oof")
            }
        }
    }
    
    func goRight() {
        let potentialEdges = player.currentQuest?.edges(from: player.currentRoom!)  
    }
    
}
