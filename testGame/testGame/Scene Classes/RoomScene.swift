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
        print(player.currentRoom)
        
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
        let potentialEdges = player.currentQuest?.edges(from: currentRoom)
        let roomExits = self.children.filter { $0 is ExitNode }
        
        let rightExit = self.childNode(withName: "rightExit")
        let rightRect = CGRect(origin: rightExit!.position, size: (rightExit?.frame.size)!)
       
//        switch self.roomType {
//            .case .upperLeft:
//            print("ehl")
//            
//        default:
//            print("hello world")
//            
//        }
        
        
        self.presentNewScene(player: player, ofFileName: (player.currentRoom?.data.name)!, andType: RoomScene())
    }

}
