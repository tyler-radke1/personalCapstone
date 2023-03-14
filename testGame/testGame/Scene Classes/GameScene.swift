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
        cameraNode.configureCamera(around: player)
        configureButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let player = self.player else { return }
        
        let location = touch.location(in: self)
        
        
        let arrows = [self.leftArrow,self.rightArrow,self.downArrow,self.upArrow]
        
        //If user selects an arrow, sets direction according and sets to walking
        for (index, arrow) in arrows.enumerated() {
            guard let arrow = arrow else { return }
            configureButtons()
            if arrow.contains(location) {
                player.directionFacing = DirectionFacing(rawValue: index)!
                player.actionDoing = .walking
                
            }
            
        }
        
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        guard let touch = touches.first else { return }
    //
    //
    //        let location = touch.location(in: self)
    //        let arrows = [leftArrow,rightArrow,downArrow,upArrow]
    //
    //        for (index, arrow) in arrows.enumerated() {
    //            if arrow.contains(location) {
    //                player.directionFacing = DirectionFacing(rawValue: index)!
    //            }
    //
    //        }
    //
    //        if attackButton.contains(location) {
    //            player.actionDoing = .attacking
    //        }
    //    }
    //
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = self.player else { return }
        //Halts the player if they're walking. Allows for other inputs such as attacks to persist.
        
        player.actionDoing = .idling
        
        let action = Animations.configureAnimation(action: player.actionDoing, direction: player.directionFacing)
        
        player.run(action)
        
        
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
        PlayerNode.player.currentQuest = newQuest.quest
        PlayerNode.player.currentRoom = newQuest.quest.adjacencies.first?.key
        
        presentNewScene(player: player, ofFileName: (player.currentRoom?.data.name)!, andType: RoomScene())
    }
    
    func presentNewScene<T>(player: PlayerNode, ofFileName file: String, andType _: T) where T: GameScene  {
        let loadQueue = DispatchQueue(label: "loadingQueue")
        loadQueue.sync {
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
}
