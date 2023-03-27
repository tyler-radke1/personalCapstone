//
//  EnemySkills.swift
//  testGame
//
//  Created by Tyler Radke on 3/24/23.
//

import Foundation
import SpriteKit


enum AllEnemySkills: CaseIterable {
    case weakAttack
    case strongAttack
    case poison
}

struct EnemyAttack {
    var description: String = ""
    
    var amount: Int = 0
    
    var attackType: AllEnemySkills
    
    func skill() {
        let reducedAmount = Int(Double(amount) * 0.6)
        PlayerNode.player.health -= (!PlayerNode.player.hasShield.hasShield) ? amount : reducedAmount
        
        if attackType == .poison {
            poisonSkill()
        }
    }
    
    private func poisonSkill() {
        PlayerNode.player.isPoisoned.isPoisoned = true
    }
    
    init(attackType: AllEnemySkills) {
        self.attackType = attackType
        
        switch attackType {
        case .weakAttack:
            self.description = "Small Attack: 10-15 damage"
            self.amount = Int.random(in: 10...15)
        case .strongAttack:
            self.description = "Big Attack: 25-30 damage"
            self.amount = Int.random(in: 25...30)
        case .poison:
            self.description = "Reduces player damage by 75% for 3 turns."
            self.amount = 0
        }
    }
}

//MARK: Old code, might reuse
////
////  EnemySkills.swift
////  testGame
////
////  Created by Tyler Radke on 3/24/23.
////
//
//import Foundation
//import SpriteKit
//
//struct EnemySkill {
//    let player = PlayerNode.player
//    let enemy = EnemyNode.enemyForBattle
//    var attack: Attack = Attack.allCases[randomInt]
//
//    func skill() {
//        switch attack {
//        case .weakEnemy:
//            <#code#>
//        case .strongEnemy:
//            <#code#>
//        case .enemyPoison:
//            <#code#>
//        }
//    }
//}
//
//
//enum Attack: CaseIterable {
//    case weakEnemy
//    case strongEnemy
//    case enemyPoison
//
//    var description: String {
//        switch self {
//        case .weakEnemy:
//            return "Small Attack: 10-15 damage"
//            //...
//        default:
//            return ""
//        }
//    }
//
//    var amount: Int {
//        switch self {
//        case .weakEnemy:
//            return Int.random(in: 10...15)
//            //...
//        default:
//            return 0
//        }
//    }
//}
//
//
//protocol EnemySkill {
//    var player: PlayerNode { get }
//    var enemy: EnemyNode { get }
//    var description: String { get }
//    var amount: Int { get }
//
//    func skill()
//}
//
//struct WeakEnemyAttack: EnemySkill {
//    let player = PlayerNode.player
//    let enemy = EnemyNode.enemyForBattle
//    let description = "Small Attack: 10-15 damage"
//
//    let amount = Int.random(in: 10...15)
//
//    func skill() {
//        if player.hasShield.hasShield {
//            let reducedAmount = Int(Double(amount) * 0.6)
//            player.health -= reducedAmount
//        } else {
//            player.health -= amount
//        }
//    }
//}
//
//struct StrongEnemyAttack: EnemySkill {
//    let player = PlayerNode.player
//    let enemy = EnemyNode.enemyForBattle
//    let description = "Big Attack: 25-30 damage"
//
//    let amount = Int.random(in: 25...30)
//
//    func skill() {
//        if player.hasShield.hasShield {
//            let reducedAmount = Int(Double(amount) * 0.6)
//            player.health -= reducedAmount
//        } else {
//            player.health -= amount
//        }
//    }
//}
//
//struct EnemyPoison: EnemySkill {
//    let player = PlayerNode.player
//    let enemy = EnemyNode.enemyForBattle
//    let description = "Poison: Reduces player damage by 75%"
//
//    let amount = Int.random(in: 25...30)
//
//    func skill() {
//        if player.hasShield.hasShield {
//            let reducedAmount = Int(Double(amount) * 0.6)
//            player.health -= reducedAmount
//        } else {
//            player.health -= amount
//        }
//
//        player.isPoisoned.isPoisoned = true
//    }
//}
//
