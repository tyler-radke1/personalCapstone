//
//  EnemyNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/17/23.
//

import UIKit
import SpriteKit
import GameplayKit

class EnemyNode: SKSpriteNode, BattleProtocol {
    
    //Putting this in main class for testing. Ideally would like to create this implementaion in each type of enemies respective subclass.
    var health = 7
    var isAlive = true
    var enemyID: UUID = UUID()
    
    var idleAnimation = EnemyAnimations.scorpionIdle
    var attackAnimation = EnemyAnimations.scorpionAttack
    
    
    static var enemies: [EnemyNode] = []
    static var enemyForBattle: EnemyNode = EnemyNode()
    
    func skill() -> Int {
        return Int.random(in: 1...10)
    }
    
    
    //Generates 1 enemy and appends it into the enemy Array
    static func generateEnemies(player: PlayerNode) {
        guard EnemyNode.enemies.count == 0 else { return }
        
        for _ in 1...5 {
            let enemy: EnemyNode = EnemyNode()
            enemy.configureEnemy()
            EnemyNode.enemies.append(enemy)
        }
        
        
    }
    
    //Sets enemy to be near the player with the right texture
    func configureEnemy() {
        let xRange = -1280...3840
        let yRange = -560...1920
        
        let x = Int.random(in: xRange)
        let y = Int.random(in: yRange)
        
        self.position = CGPoint(x: x, y: y)
        
        self.name = "enemy"
        
        self.texture = SKTexture(imageNamed: "scorpion_idle_000")
        
        self.zPosition = 1
        
        self.alpha = 1
        
        self.size = CGSize(width: 350, height: 350)
    }
    
    static func addEnemies(scene: SKScene) {
        /* First removes all children of type EnemyNode
         Then loops through enemies array, and if it is a defeated enemyForBattle, skips over it
         any other enemy gets rerendered on the screen.
         */
        for child in scene.children {
            if child is EnemyNode {
                child.removeFromParent()
            }
        }
        
        for (index, enemy) in enemies.enumerated() {
            if enemy == EnemyNode.enemyForBattle && EnemyNode.enemyForBattle.isAlive == false {
                EnemyNode.enemies.remove(at: index)
                continue
            } else {
                scene.addChild(enemy)
            }
        }
    }
    
    
    func prepareToChangeScene() {
        self.removeFromParent()
        self.removeAllChildren()
    }
    
}

