//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 2/14/23.
//

import Foundation
import SpriteKit
import GameplayKit

extension GameScene {
    func configureNodes() {
        upArrow = self.childNode(withName: "upArrow")! as! ArrowNode
        downArrow = self.childNode(withName: "downArrow")! as! ArrowNode
        leftArrow = self.childNode(withName: "leftArrow")! as! ArrowNode
        rightArrow = self.childNode(withName: "rightArrow")! as! ArrowNode
    
        player?.configurePlayer()
        if let player = player {
            self.addChild(player)
        }

        for child in self.children {
            if let child = child as? EnemyNode {
                child.run(child.idleAnimation)
                
            }
        }
    }
}
