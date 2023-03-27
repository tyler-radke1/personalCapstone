//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 2/24/23.
//

import Foundation
import SpriteKit

protocol SkillProtocol {
    var description: String { get set }
    var texture: SKTexture { get }
    var player: PlayerNode { get set }
    var enemy: EnemyNode { get set }
    var coolDown: Int { get set }
    //Length of an effect if it expires, nil otherwise
    mutating func skill()
}

struct Attack: SkillProtocol {
    let texture = SKTexture(image: UIImage(named: "SwordIcon")!)
    var description = "Attack: Does 1-10 damage to enemy"
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    var coolDown = 0
    mutating func skill() {
        let damage = Int.random(in: 1...10)
        self.enemy.health -= damage
    }
    
}

struct BigAttack: SkillProtocol {
    let texture = SKTexture(image: UIImage(named: "axeShadow")!)
    var description = "Tyler's Super Attack: Does 500-600 damage to enemy. For testing."
    
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    
    var coolDown = 0
    
    mutating func skill() {
        guard coolDown == 0 else { return }
        let damage = Int.random(in: 500...600)
        //let damage = 100
        enemy.health -= !(PlayerNode.player.isPoisoned.isPoisoned) ? damage : Int(Double(damage) * 0.25)
        coolDown = 3
    }
}

struct Stun: SkillProtocol {
    let texture = SKTexture(image: UIImage(named: "Daze")!)
    var description = "Does 25-30 damage and stuns enemy for 3 turns"
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    var coolDown = 0
    var effectLength: Int = 3
    
    mutating func skill() {
        guard coolDown == 0 else { return }
        let damage = Int.random(in: 25...30)
        enemy.health -= !(PlayerNode.player.isPoisoned.isPoisoned) ? damage : Int(Double(damage) * 0.25)
        enemy.stunEffect = (true, 3)
        coolDown = 6
    }
}

struct Shield: SkillProtocol {
    var description = "Protects player from 40% of all damage recieved for 3 turns."
    
    var texture = SKTexture(image: UIImage(named: "Shield")!)
    
    var player: PlayerNode = PlayerNode()

    var enemy: EnemyNode = EnemyNode()
    
    var coolDown: Int = 0
    
    mutating func skill() {
        PlayerNode.player.hasShield.0 = true
        coolDown = 6
    }
}

struct Heal: SkillProtocol {
    var description: String = "Heals the player for between 10 - 30 health."
    
    var texture = SKTexture(image: UIImage(named: "HealthPotion")!)
    
    var player: PlayerNode = PlayerNode()
    
    var enemy: EnemyNode = EnemyNode()
    
    var coolDown: Int = 0
    
    mutating func skill() {
        let amount = Int.random(in: 10...30)
        PlayerNode.player.health += amount
        coolDown = 7
    }
}






