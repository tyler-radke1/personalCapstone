//
//  ArrowNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/16/23.
//

import UIKit
import SpriteKit

class ArrowNode: SKSpriteNode {
    var directionFacing: DirectionFacing = .other
    
    //Function takes an array of arrows and sets them appropriately around a player.
    static func configureArrows(arrows: [ArrowNode?], player: PlayerNode) {
        /*
         Player: 0, 0
         
         Right Arrow: -685 -310
         Left Arrow: -950 -310
         
         Up Arrow:  -815 -170
         Down Arrow: -815 -430
         */
        let playerX = player.position.x
        let playerY = player.position.y + 300
        
        arrows[0]?.position = CGPoint(x: playerX - 685, y: playerY - 310)
        arrows[1]?.position = CGPoint(x: playerX - 950, y: playerY - 310)

        arrows[2]?.position = CGPoint(x: playerX - 815, y: playerY - 170)
        arrows[3]?.position = CGPoint(x: playerX - 815, y: playerY - 430)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PlayerNode.player.directionFacing = self.directionFacing
    }
    
    static func disableArrows(arrows: [ArrowNode]) {
        arrows.forEach({ $0.isPaused = true})
    }

}
