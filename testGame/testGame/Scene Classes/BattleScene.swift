//
//  BattleScene.swift
//  testGame
//
//  Created by Tyler Radke on 2/18/23.
//

import UIKit
import SpriteKit

//This protocol enables healthbar configuration to be consolitdated into one function that can handle both player and enemy. Protocol just uses all functions both classes need to set up healthbar.
protocol BattleProtocol {
    var health: Int { get set }
    func addChild(_ node: SKNode)
    func removeAllChildren()
}

class BattleScene: GameScene {
    
    // var enemy: EnemyNode = EnemyNode()
    var enemy: EnemyNode = EnemyNode.enemyForBattle
    var isPlayersTurn = true
    var isAttacking = false
    var sceneToReturnTo: GameScene? = nil
    var playerSkills: [SkillProtocol] = [Attack(), BigAttack(), Stun(), Shield(), Heal()]
    var theCamera = SKCameraNode()
    override func didMove(to view: SKView) {
        guard let player = self.player else { return }
        theCamera.position = CGPoint(x: 0, y: 0)
        self.camera = theCamera
        //Configure universal nodes and nodes specifically for battle
        configureNodes()
        configureBattle()
        configureHealthBars(beings: [player, enemy])
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let player = self.player else { return }
        super.update(currentTime)
        configureHealthBars(beings: [player, enemy])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Currently, no touches do anything uness its your turn
        guard let touch = touches.first, isPlayersTurn == true else { return }
        
        let location = touch.location(in: self)
        self.children.filter({ $0 is SkillIconNode}).forEach({ skill in
            guard skill.contains(location) && (skill as! SkillIconNode).skill.coolDown == 0 else { return }
            //let skill = skill as! SkillIconNode
            isAttacking = true
           // skill.skill.skill()
        })
//
        let flee: SKSpriteNode = self.childNode(withName: "flee") as! SKSpriteNode
        
        if flee.contains(location) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: returnToGameScene)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAttacking, let location = touches.first?.location(in: self) else { return }
        self.view?.isUserInteractionEnabled = false
        
        self.children.filter({ $0 is SkillIconNode}).forEach({ skill in
            guard skill.contains(location) && (skill as! SkillIconNode).skill.coolDown == 0 else { return }
            let skill = skill as! SkillIconNode
            isAttacking = true
            skill.skill.skill()
            playerTurn()
        })
    }
    
    func playerTurn() {
        guard let player = self.player else { return }
        isAttacking = false
        guard enemy.health >= 0 else {
            //Code to be run when enemy dies
            player.run(Animations.attackRight)
            enemy.health = 0
            enemy.run(EnemyAnimations.scorpionDeath) {
                self.view?.isUserInteractionEnabled = true
                self.player?.currentRoom?.removeEnemies(with: self.enemy.enemyID)
                self.returnToGameScene()
            }
            return
        }
        
        player.run(Animations.attackRight) {
            self.enemy.run(EnemyAnimations.scorpionHurt)
        }
        
        //Lowers cooldown for each skill by 1, unless its already 0
        let allSkillIcons = self.children.filter({ $0 is SkillIconNode })
        allSkillIcons.forEach({
            let skillIcon = ($0 as! SkillIconNode)
            skillIcon.skill.coolDown -= (skillIcon.skill.coolDown) != 0 ? 1 : 0
        })
        NotificationCenter.default.post(name: NSNotification.Name("coolDown"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.enemyTurn()
        }
        
    }
    
    func enemyTurn() {
        guard let player = player, !enemy.stunEffect.isStunned else {
            self.view?.isUserInteractionEnabled = true
            reduceEffectLength()
            return
        }
        
        enemy.run(EnemyAnimations.scorpionAttack) {
            player.run(Animations.hurtRight) {
                self.view?.isUserInteractionEnabled = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let reducedAttack = Double((self.enemy.skill())) * 0.6
            player.health -= (player.hasShield.0) ? Int(reducedAttack) : (self.enemy.skill())
            self.isPlayersTurn = true
            if player.health <= 0 {
                self.view?.isUserInteractionEnabled = true
                self.returnToGameScene()
            }
        }
        reduceEffectLength()
    }
    
    func configureHealthBars(beings: [BattleProtocol]) {
        for being in beings {
            being.removeAllChildren()
            let healthBar = SKSpriteNode(imageNamed: "health100")
            
            healthBar.xScale = 2.75; healthBar.yScale = 6
            healthBar.size.width = 250
            healthBar.position.y += 150
            
            let textNode = SKLabelNode(text: "\(being.health)")
            textNode.fontSize = 9
            
            textNode.xScale *= (being is EnemyNode) ?  -2 : 2
            textNode.fontName = "Arial Bold"
            textNode.zPosition = 1
            textNode.position.y -= 4
            
            healthBar.addChild(textNode)
            being.addChild(healthBar)
            
        }
    }
    
    @objc func coolDownChanged( _ notification: Notification) {        
        let allSkillIcons = self.children.filter({ $0 is SkillIconNode })
        allSkillIcons.forEach({
            let labelNode = ($0 as! SkillIconNode).childNode(withName: "coolDownLabel") as? SKLabelNode
            labelNode?.text = "\(($0 as! SkillIconNode).skill.coolDown)"
        })
    }
    
    func reduceEffectLength() {
        guard let player = player else { return }
        if player.hasShield.hasShield {
            player.hasShield.turnsRemaining -= 1
            if player.hasShield.turnsRemaining == 0 {
                player.hasShield.hasShield = false
                player.hasShield.turnsRemaining = 3
            }
        }
        
        if enemy.stunEffect.isStunned {
            enemy.stunEffect.turnsRemaining -= 1
            
            if enemy.stunEffect.turnsRemaining == 0 {
                enemy.stunEffect.turnsRemaining = 3
                enemy.stunEffect.isStunned = false
            }
        }
    }
    
    
    func configureBattle() {
        guard let player = self.player else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(coolDownChanged(_ :)), name: NSNotification.Name("coolDown"), object: nil)
        enemy = EnemyNode.enemyForBattle
        enemy.configureEnemy()
        
        self.addChild(enemy)
        player.position = CGPoint(x: -315, y: -222)
        player.run(Animations.idleDown)
        
        // self.enemy = Enemies.enemy
        enemy.xScale *= -1
        
        enemy.run(enemy.idleAnimation)
        enemy.position = CGPoint(x: 325, y: -222)
        
        
        let skillIcons = self.children.filter({ $0 is SkillIconNode})
        
        for (index, skillIcon) in skillIcons.enumerated() {
            if let skillIcon = (skillIcon as? SkillIconNode) {
                skillIcon.skill = playerSkills[index]
                let label = SKLabelNode(text: "\(skillIcon.skill.coolDown)")
                label.fontColor = UIColor.white
                label.fontName = "Arial Bold"
                label.fontSize = 14
                label.position = CGPoint(x: -15, y: -20)
                label.name = "coolDownLabel"
                skillIcon.addChild(label)
            }
        }
    }
    
    ///TODO: Refactor this to just return back to previous screen, rather than specifically the GameScene
    func returnToGameScene() {
        guard let scene = (enemy.isBoss == false) ? sceneToReturnTo : GameScene(fileNamed: "GameScene"), let player = self.player else { return }
        scene.player = player
        scene.scaleMode = .aspectFit
        EnemyNode.enemyForBattle.prepareToChangeScene()
        enemy.prepareToChangeScene()
        player.prepareForScene()
        self.scene?.view?.presentScene(scene, transition: .moveIn(with: .up, duration: 0.5))
    }
}
