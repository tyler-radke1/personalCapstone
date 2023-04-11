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
            guard skill.contains(location) && (skill as! SkillIconNode).skill.coolDown == 0 else {
                //allows player read skill descriptions at any time
                if skill.contains(location) {
                    createSkillInfoPopup(text: (skill as! SkillIconNode).skill.description)
                }
                return
            }
            let skill = skill as! SkillIconNode
            isAttacking = true
            createSkillInfoPopup(text: skill.skill.description)
        })

        let flee: SKSpriteNode = self.childNode(withName: "flee") as! SKSpriteNode
        
        if flee.contains(location) {
           returnToGameScene()
        }
        
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.childNode(withName: "popUpRect")?.removeFromParent()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isAttacking, let location = touches.first?.location(in: self) else { return }
        self.childNode(withName: "popUpRect")?.removeFromParent()
        //Disables input until the turn is over, executes player skill & turn
        self.children.filter({ $0 is SkillIconNode}).forEach({ skill in
            guard skill.contains(location) && (skill as! SkillIconNode).skill.coolDown == 0 else { return }
            self.view?.isUserInteractionEnabled = false
            let skill = skill as! SkillIconNode
            isAttacking = true
            skill.skill.skill()
            playerTurn()
        })
    }
    
    func playerTurn() {
        guard let player = self.player else { return }
        isAttacking = false
        //Code to be run when enemy dies
        
        guard enemy.health >= 0 else {
            player.run(Animations.attackRight)
            enemy.health = 0
            enemy.run(EnemyAnimations.scorpionDeath) {
                //create popup detailing xp given
                //wait 1 second
                self.view?.isUserInteractionEnabled = true
                self.player?.currentRoom?.removeEnemies(with: self.enemy.enemyID)
                self.returnToGameScene()
                
                let saveFile = GameData.sharedInstance
                saveFile.exp = player.exp
                saveFile.level = player.level
                saveFile.save()
            }
            
            self.createBattleWonPopup()
            return
        }
        
        player.run(Animations.attackRight) {
            self.enemy.run(EnemyAnimations.scorpionHurt)
        }
        
        //Lowers cooldown for each skill by 1, unless its already 0, then sends a notification to update the cooldown label
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
            let attack = EnemyAttack(attackType: AllEnemySkills.allCases.randomElement()!)
            print(attack.description)
            attack.skill()
            self.isPlayersTurn = true
            if player.health <= 0 {
                self.view?.isUserInteractionEnabled = true
                self.returnToGameScene()
            }
        }
        reduceEffectLength()
    }
    

    
    @objc func coolDownChanged( _ notification: Notification) {        
        let allSkillIcons = self.children.filter({ $0 is SkillIconNode })
        allSkillIcons.forEach({
            let labelNode = ($0 as! SkillIconNode).childNode(withName: "coolDownLabel") as? SKLabelNode
            labelNode?.text = "\(($0 as! SkillIconNode).skill.coolDown)"
        })
    }
    
    func reduceEffectLength() {
        //Any turns remaining on the player or enemy, lowers by 1
        guard let player = player else { return }
        
        if player.hasShield.hasShield {
            guard player.hasShield.turnsRemaining >= 1 else {
                player.hasShield.hasShield = false
                player.hasShield.turnsRemaining = 3
                return
            }
            player.hasShield.turnsRemaining -= 1
        }
        
        if enemy.stunEffect.isStunned {
            guard enemy.stunEffect.turnsRemaining >= 1 else {
                enemy.stunEffect.turnsRemaining = 3
                enemy.stunEffect.isStunned = false
                return
            }
            enemy.stunEffect.turnsRemaining -= 1
        }
    }
    
    //MARK: Configuration Functions
    
    //Creates a popup to detail the skill
    func createSkillInfoPopup(text: String) {
        let text = SKLabelNode(text: text)
        text.name = "popUp"
        text.fontName = "Arial Bold"
        text.fontSize = 30
        text.fontColor = UIColor.white
        
        let shape = SKShapeNode(rect: CGRect(x: 0, y: 0, width: text.frame.width, height: 100))
        shape.name = "popUpRect"
        shape.fillColor = UIColor.darkGray
        shape.addChild(text)
        shape.zPosition = 2
        text.zPosition = 2
        text.verticalAlignmentMode = .center
        text.horizontalAlignmentMode = .center
        text.position = CGPoint(x: shape.frame.width / 2, y: shape.frame.height / 2)
        
        self.addChild(shape)
    }
    
    func updateGameDataStats() {
        guard let player = self.player, player.exp >= player.expNeeded else {
            return
        }
        
        player.level += 1
        player.exp = 0
        player.health = player.level / 4 + (100 + player.level^2)
        player.expNeeded = player.level * (100 + player.level * 10)
        //saveFile.expNeeded = player.level * (100 + player.level * 10)

        print("exp needed - \(player.expNeeded)")
    
    }
    //Creates a popup to detail results of a battle won
    func createBattleWonPopup() {
        guard let player else { return }
        let saveFile = GameData.sharedInstance
        let maxExp = saveFile.level * (saveFile.level + 20)
        let minExp = saveFile.level * (saveFile.level + 10)
        let expRange = minExp...maxExp
        
        let expToGive = Int.random(in: expRange)
        //saveFile.exp += expToGive
        player.exp += expToGive
        updateGameDataStats()
        let text = "Congratulations! You earned \(expToGive) experience."
        let textNode = SKLabelNode(text: text)
        textNode.name = "popUp"
        textNode.fontName = "Arial Bold"
        textNode.fontSize = 30
        textNode.fontColor = UIColor.white
        
//        let shape = SKShapeNode(rect: CGRect(x: (view?.frame.width ?? 0) / 2, y: (view?.frame.height ?? 0) / 3, width: textNode.frame.width, height: 100))
//        shape.name = "popUpRect"
//        shape.fillColor = UIColor.darkGray
//        shape.addChild(textNode)
        textNode.verticalAlignmentMode = .center
        textNode.horizontalAlignmentMode = .center

        self.addChild(textNode)
    }
    
    //Run when battle is first loaded up
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
    
    func configureHealthBars(beings: [BattleProtocol]) {
        for being in beings {
            being.removeAllChildren()
            let healthBar = SKSpriteNode(imageNamed: "health100")
            
            healthBar.xScale = 3; healthBar.yScale = 2.75
            healthBar.size.width = 250
            healthBar.position.y += (being is EnemyNode && (being as! EnemyNode).isBoss) ? 90 : 150
            healthBar.zPosition = 1
            
            let textNode = SKLabelNode(text: "\(being.health)")
            textNode.fontSize = 9
            
            textNode.xScale *= (being is EnemyNode) ?  -1.2 : 1.2
            textNode.fontSize = 15
            textNode.fontName = "Arial Bold"
            textNode.zPosition = 1
            textNode.position.y -= 4
            
            healthBar.addChild(textNode)
            being.addChild(healthBar)
            
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
