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
    var isBoss = false
    var enemyID: UUID = UUID()
    var stunEffect: (isStunned: Bool, turnsRemaining: Int) = (false, 0)
    var idleAnimation = EnemyAnimations.scorpionIdle
    var attackAnimation = EnemyAnimations.scorpionAttack
    
    static var enemyForBattle: EnemyNode = EnemyNode()
    
    func skill() -> Int {
        return Int.random(in: 15...20)
    }
    
    
    //Sets enemy to be near the player with the right texture
    func configureEnemy() {
        let xRange = -2560...2560
        let yRange = -1280...1280
        let saveFile = GameData.sharedInstance
        
        let playerMaxHealth = saveFile.level/4 + (100 + saveFile.level^2)
        
        let x = Int.random(in: xRange)
        let y = Int.random(in: yRange)
        
        self.position = CGPoint(x: x, y: y)
        
        self.name = "enemy"
        
        self.texture = SKTexture(image: UIImage(named: "scorpion_idle_000")!)
        
        let baseHealthMultiplier = Int.random(in: 60...70)
        self.health = Int(Double(playerMaxHealth) * (Double(baseHealthMultiplier) / 100))
        self.zPosition = 1
        
        self.alpha = 1
        
        self.size = CGSize(width: 350, height: 350)
        
        if self.isBoss {
            self.configureBoss()
        }
    }
    
    func configureBoss() {
        //self.configureEnemy()
        let saveFile = GameData.sharedInstance
        let playerMaxHealth = saveFile.level/4 + (100 + saveFile.level^2)
        self.health = Int(Double(playerMaxHealth) * 1.75)
        self.xScale *= 2
        self.yScale *= 2
    }
    
    
    func prepareToChangeScene() {
        self.removeFromParent()
        self.removeAllChildren()
    }
}

