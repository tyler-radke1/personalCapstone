//
//  GameScene.swift
//  testGame
//
//  Created by Tyler Radke on 2/13/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var player: PlayerNode? = PlayerNode.player
    
    weak var leftArrow: ArrowNode? = nil
    weak var rightArrow: ArrowNode? = nil
    weak var downArrow: ArrowNode? = nil
    weak var upArrow: ArrowNode? = nil
    
    weak var enemyToDelete: EnemyNode?
    var willDelete = false
    let cameraNode = SKCameraNode()
    // var enemy: EnemyNode = EnemyNode(imageNamed: "scorpion_idle_000")
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        self.camera = cameraNode
        configureButtons()
        configureNodes()
    }
    
    override func sceneDidLoad() {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        guard let player = self.player else { return }
        
        if playerCollidesWith(type: BuildingNode()) {
            self.player?.isColliding = true
            
            if let node = self.childNode(withName: "questTrigger") {
                if player.intersects(node) {
                    createQuest()
                }
            }
        }
        
        player.movePlayer()
    }
    
    override func didFinishUpdate() {
        guard let player = self.player else { return }
        player.removeFromParent()
        self.addChild(player)
        cameraNode.configureCamera(around: player)
        configureButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        theTouchFunction(touches: touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        theTouchFunction(touches: touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = self.player else { return }
        //Halts the player if they're walking. Allows for other inputs such as attacks to persist.
        player.actionDoing = .idling
        player.run(GameViewController.idleActions[player.directionFacing]!)
    }
    
    
    
    
    
    func theTouchFunction(touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let player = self.player else { return }
        
        let location = touch.location(in: self)
        
        let arrows = [leftArrow, rightArrow, downArrow, upArrow]
        let directionDict: [ArrowNode? : DirectionFacing] = [
            leftArrow: .left,
            rightArrow: .right,
            upArrow: .up,
            downArrow: .down
        ]
        //  If user selects an arrow, sets direction according and sets to walking
        let backgroundQueue = DispatchQueue(label: "animation")
        backgroundQueue.async {
            for arrow in arrows {
                guard let arrow = arrow, arrow.contains(location) else { continue }
                player.directionFacing = directionDict[arrow]!
                player.actionDoing = .walking
                player.run(Animations.walkActions[player.directionFacing]!)
                return
            }
        }
    }
    
    func configureButtons() {
        guard let player = self.player else { return }
        let arrows = [self.rightArrow, self.leftArrow, self.upArrow, self.downArrow]
        
        ArrowNode.configureArrows(arrows: arrows, player: player)
    }
    
    //This function checks if the player has collided with a node of type T.
    //Sets the isColliding value of the player to true if it is.
    func playerCollidesWith<T: SKSpriteNode>(type: T) -> Bool{
        let arrayOfNodes: [SKNode] = self.children.filter { $0 is T }
        
        for node in arrayOfNodes {
            let playerX = PlayerNode.player.position.x
            let playerY = PlayerNode.player.position.y
            
            let rect = CGRect(x: playerX, y: playerY, width: 0, height: 0)
            
            if rect.intersects(node.frame) {
                return true
            }
        }
        return false
    }
    
    func createQuest() {
        guard let player = self.player else { return }
        let newQuest = Quest()
        newQuest.createGraph()
        PlayerNode.player.currentQuest = newQuest
        PlayerNode.player.currentRoom = newQuest.quest.adjacencies.first?.key
        
        presentNewScene(player: player, ofFileName: (player.currentRoom?.data.name)!, andType: RoomScene())
    }
    
    func presentNewScene<T>(player: PlayerNode, ofFileName file: String, andType _: T) where T: GameScene  {
        let newScene = T(fileNamed: file)
        newScene!.player = player
        
        if let newScene = newScene as? BattleScene {
            newScene.sceneToReturnTo = self
        }
        
        newScene?.scaleMode = .aspectFit
        
        player.prepareForScene()
        EnemyNode.enemyForBattle.prepareToChangeScene()
        
        for child in self.children {
            if child is EnemyNode {
                child.removeFromParent()
            }
        }
        
        self.scene?.view?.presentScene(newScene!, transition: .moveIn(with: .up, duration: 0.5))
    }
}
