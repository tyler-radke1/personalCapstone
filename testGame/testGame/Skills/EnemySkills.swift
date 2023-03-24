//
//  EnemySkills.swift
//  testGame
//
//  Created by Tyler Radke on 3/24/23.
//

import Foundation
import SpriteKit

protocol EnemySkill {
    var player: PlayerNode { get }
    var enemy: EnemyNode { get }
    var description: String { get }
    var amount: Int { get }
    
    func skill()
}
struct WeakEnemyAttack: EnemySkill {
    let player = PlayerNode.player
    let enemy = EnemyNode.enemyForBattle
    let description = "Small Attack: 10-15 damage"
    
    let amount = Int.random(in: 10...15)
    
     func skill() {
        if player.hasShield.hasShield {
            let reducedAmount = Int(Double(amount) * 0.6)
            player.health -= reducedAmount
        } else {
            player.health -= amount
        }
    }
}

struct StrongEnemyAttack: EnemySkill {
    let player = PlayerNode.player
    let enemy = EnemyNode.enemyForBattle
    let description = "Big Attack: 25-30 damage"
    
    let amount = Int.random(in: 25...30)
    
    func skill() {
       if player.hasShield.hasShield {
           let reducedAmount = Int(Double(amount) * 0.6)
           player.health -= reducedAmount
       } else {
           player.health -= amount
       }
   }
}

struct EnemyPoison: EnemySkill {
    let player = PlayerNode.player
    let enemy = EnemyNode.enemyForBattle
    let description = "Poison: Reduces player damage by 75%"
    
    let amount = Int.random(in: 25...30)
    
    func skill() {
       if player.hasShield.hasShield {
           let reducedAmount = Int(Double(amount) * 0.6)
           player.health -= reducedAmount
       } else {
           player.health -= amount
       }
   }
    
    
}

