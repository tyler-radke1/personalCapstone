//
//  DesertQuest.swift
//  testGame
//
//  Created by Tyler Radke on 2/26/23.
//

import UIKit
import SpriteKit

class DesertQuest: GameScene {
    
    override func didMove(to view: SKView) {
        self.camera = cameraNode
        configureNodes()
        
        
        EnemyNode.generateEnemies(player: player)
        
        
        EnemyNode.addEnemies(scene: self)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
}
