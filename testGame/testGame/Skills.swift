//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 2/24/23.
//

import Foundation
import SpriteKit

protocol SkillProtocol {
    static var description: String { get set }
    var player: PlayerNode { get set }
    var enemy: EnemyNode { get set }
    var coolDown: Int { get set }
    mutating func skill()
    
}

struct Attack: SkillProtocol {
    static var description = "Does 1-10 damage to enemy"
    var player = PlayerNode()
    var enemy = EnemyNode()
    var coolDown = 0
    mutating func skill() {
        let damage = Int.random(in: 1...10)
        self.enemy.health -= damage
    }
    
}


struct BigAttack: SkillProtocol {
    static var description = "Does 50-60 damage to enemy. For testing."
    
    var player: PlayerNode
    
    var coolDown = 0
    
    var enemy: EnemyNode
    
    mutating func skill() {
        guard coolDown == 0 else { return }
        let damage = Int.random(in: 15...20)
        enemy.health -= damage
        coolDown = 3
    }
    
    
}



