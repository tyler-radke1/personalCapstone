//
//  DesertQuest.swift
//  testGame
//
//  Created by Tyler Radke on 2/26/23.
//

import UIKit
import SpriteKit
enum enterAndExitDirections {
    case left, right, top, bottom
}

class RoomScene: GameScene {
    
    var enters: enterAndExitDirections = .left
    var exits: enterAndExitDirections = .right
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        player.inputView?.bringSubviewToFront(view)
        EnemyNode.generateEnemies(player: player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        
    }
    
}
