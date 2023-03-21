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
    var texture: SKTexture { get }
    var player: PlayerNode { get set }
    var enemy: EnemyNode { get set }
    var coolDown: Int { get set }
    //Length of an effect if it expires, nil otherwise
    mutating func skill()
}

protocol DefensiveSkillProtocol: SkillProtocol {
    var effectLength: Int { get set }
    mutating func reduceEffectLength()
}
struct Attack: SkillProtocol {
    let texture = SKTexture(imageNamed: "SwordIcon")
    static var description = "Does 1-10 damage to enemy"
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    var coolDown = 0
    mutating func skill() {
        let damage = Int.random(in: 1...10)
        self.enemy.health -= damage
    }
    
}

struct BigAttack: SkillProtocol {
    let texture = SKTexture(imageNamed: "axeShadow")
    static var description = "Does 50-60 damage to enemy. For testing."
    
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    
    var coolDown = 0
    
    mutating func skill() {
        guard coolDown == 0 else { return }
        let damage = Int.random(in: 50...60)
        enemy.health -= damage
        coolDown = 3
    }
}

struct Stun: SkillProtocol, DefensiveSkillProtocol {
    let texture = SKTexture(imageNamed: "Daze")
    static var description = "Does 25-30 damage and stuns enemy for 3 turns"
    var player: PlayerNode = PlayerNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    var coolDown = 0
    var effectLength: Int = 3
    
    mutating func skill() {
        guard coolDown == 0 else { return }
        let damage = Int.random(in: 25...30)
        enemy.health -= damage
        enemy.stunEffect = (true, 3)
        coolDown = 6
    }
    
   mutating func reduceEffectLength() {
       guard enemy.stunEffect.isStunned else { return }
       
        effectLength -= 1
       if effectLength == 0 {
           enemy.stunEffect.isStunned = false
           effectLength = 3
       }
    }
}

struct Shield: SkillProtocol, DefensiveSkillProtocol {
    static var description = "Adds shield to the player, protecting them from 40% of all damage recieved for 3 turns."
    
    var texture: SKTexture = SKTexture(imageNamed: "Shield")
    
    var player: PlayerNode = PlayerNode()

    var enemy: EnemyNode = EnemyNode()
    
    var coolDown: Int = 0
    var effectLength: Int = 3
    
    mutating func reduceEffectLength() {
        guard PlayerNode.player.hasShield else { return }
       // print(self.effectLength)
        self.effectLength -= 1
       // print(self.effectLength)
//        if effectLength == 0 {
//            PlayerNode.player.hasShield = false
//            effectLength = 3
//        }
    }
    
    mutating func skill() {
        PlayerNode.player.hasShield = true
        coolDown = 6
    }
}






