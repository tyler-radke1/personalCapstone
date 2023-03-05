//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 2/22/23.
//

import Foundation
import SpriteKit

struct EnemyAnimations {
    
    static let scorpionIdle = SKAction.repeatForever(SKAction(named: "scorpionIdle")!)
    static let scorpionAttack = SKAction.repeat(SKAction(named: "scorpionAttack", duration: 0.5)!, count: 1)
    static let scorpionDeath = SKAction.repeat(SKAction(named: "scorpionDeath")!, count: 1)
    static let scorpionHurt = SKAction.repeat(SKAction(named: "scorpionHurt", duration: 0.5)!, count: 1)
    

}
