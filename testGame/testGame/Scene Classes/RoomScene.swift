//
//  DesertQuest.swift
//  testGame
//
//  Created by Tyler Radke on 2/26/23.
//


import UIKit
import SpriteKit
enum RoomType {
    case upperLeft
    case forkDown
    case upperRight
    case lowerLeft
    case forkUp
    case lowerRight
}

class RoomScene: GameScene {
    var roomType: RoomType? = nil
    var bossRoom: Bool {
        let chance = Int.random(in: 1...8)
        return chance == 5
    }
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.player?.position = CGPoint(x: 0, y: 0)
        
        if !bossRoom {
            self.player?.currentRoom?.addEnemies(scene: self)
            print("is not a boss room")
        } else {
            let boss = EnemyNode()
            boss.isBoss = true
            boss.configureEnemy()
            self.addChild(boss)
            print("is a boss room")
        }
        generatePlayerStats()
    }
    
    override func sceneDidLoad() {
        self.roomType = configureRoomType()
        cameraNode.configureCamera(around: self.player!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if playerCollidesWith(type: ExitNode()) {
            configureRoomExit()
        }
        
        if playerCollidesWith(type: EnemyNode()) {
            configureEnemy()
        }
        configureButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    func generatePlayerStats() {
        guard let player = player else { return }
        //Health Bar
        let healthBar = SKSpriteNode(imageNamed: "health100")
        
        healthBar.xScale = 3; healthBar.yScale = 2.75
        healthBar.size.width = 250
        healthBar.position.y += (view?.frame.maxY)! * 2
        healthBar.position.x -= (view?.frame.maxX)!
        
        let textNode = SKLabelNode(text: "\(player.health)")
        textNode.fontSize = 9
        
        textNode.xScale *= 1.2
        textNode.fontName = "Arial Bold"
        textNode.zPosition = 1.5
        textNode.position.y -= 4
        
        healthBar.addChild(textNode)
        player.addChild(healthBar)
        
        //Level & Experience
        let levelBar = SKShapeNode(rect: CGRect(x: -100, y: 400, width: 100, height: 100))
        levelBar.fillColor = UIColor.green
        
        let levelText = SKLabelNode(text: "Level: \(player.level) EXP: \(player.exp)/\(player.expNeeded)")
        levelText.fontName = "Arial Bold"
       // levelBar.addChild(levelText)
        levelText.position = CGPoint(x: -500, y: view!.frame.maxY * 2)
        player.addChild(levelText)
    }
    
    func configureEnemy() {
        guard let player = player else { return }
        
        let enemies = self.children.filter({ $0 is EnemyNode })
        
        for enemy in enemies {
            guard player.intersects(enemy) else { continue }
            EnemyNode.enemyForBattle = enemy as! EnemyNode
            self.player?.prepareForScene()
           //PlayerNode.player.positionToMoveTo = player.position
           self.presentNewScene(player: player, ofFileName: "Battle", andType: BattleScene())
        }
    }
    
    func configureRoomType() -> RoomType {
        if let player = self.player {
            
            switch player.currentRoom?.data.name {
            case "Room1":
                return .upperLeft
            case "Room2":
                return .forkDown
            case "Room3":
                return .upperRight
            case "Room4":
                return .lowerLeft
            case "Room5":
                return .forkUp
            case "Room6":
                return .lowerRight
            default:
                return .upperLeft
            }
        }
        return .upperLeft
    }
    
    func configureRoomExit() {
        guard let player = player, let quest = player.currentQuest else { return }
        let roomExits = self.children.filter { $0 is ExitNode }
        let exit = roomExits.first { player.intersects($0) }
        let type = exit?.userData?["exitType"]
        
        switch type as? String {
        case "right":
            // player.positionToMoveTo = CGPoint(x: -700, y: player.position.y)
            generateRoom(roomsToCheckFor: quest.roomsExitLeft)
        case "left":
            //  player.positionToMoveTo = CGPoint(x: 3400, y: player.position.y)
            generateRoom(roomsToCheckFor: quest.roomsExitRight)
        case "top":
            //   player.positionToMoveTo = CGPoint(x: player.position.x, y: -500)
            generateRoom(roomsToCheckFor: quest.roomsExitDown)
        case "bottom":
            //  player.positionToMoveTo = CGPoint(x: player.position.x, y: 1700)
            generateRoom(roomsToCheckFor: quest.roomsExitUp)
        default:
            print("oof")
        }
        
    }

    func generateRoom(roomsToCheckFor: [RoomScene?]) {
       guard let player = player, let currentRoom = player.currentRoom, let potentialEdges = player.currentQuest?.quest.edges(from: currentRoom) else { return }
       
        let roomsAsNames = roomsToCheckFor.map { $0?.name }
    
        for edge in potentialEdges {
            if roomsAsNames.contains(edge.destination.data.name) {
                player.currentRoom = edge.destination
                presentNewRoom(player: player, scene: edge.destination.data)
            }
        }
    }
    
    func presentNewRoom(player: PlayerNode, scene: RoomScene) {
        //scene.player = player
        scene.scaleMode = .aspectFit
        player.prepareForScene()
        EnemyNode.enemyForBattle.prepareToChangeScene()
        
        for child in self.children {
            if child is EnemyNode {
                child.removeFromParent()
            }
        }
        self.scene?.view?.presentScene(scene)
    }
}
