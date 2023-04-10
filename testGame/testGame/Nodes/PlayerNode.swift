//
//  PlayerNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/13/23.
//

import SpriteKit
import GameplayKit

enum DirectionFacing: Int {
    case left = 0
    case right
    case down
    case up
    case other
}

enum ActionDoing {
    case walking
    case idling
    
  //  case attacking
}

class PlayerNode: SKSpriteNode, BattleProtocol {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        let saveFile = GameData.sharedInstance
        
        self.level = saveFile.level
        self.health = saveFile.level/3 + (100 + saveFile.level * saveFile.level)
        self.exp = saveFile.exp
        self.expNeeded = level * (100 + level * 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var directionFacing: DirectionFacing = .down {
        didSet {
            switch self.directionFacing {
            case .left:
                self.oppositeDirection = .right
            case .right:
                self.oppositeDirection = .left
            case .up:
                self.oppositeDirection = .down
            case .down:
                self.oppositeDirection = .up
            case .other:
                print()
            }
        }
    }
    var playerSpeed: CGFloat = 15
    var isColliding = false
    
    
    var level = 1
    var exp = 0
    var expNeeded = 0

    var health = 100
    //Health Formula based on level (x) - x/4 + (100 + x^2)

    //MARK: Status effect variables, such as stuns, heals, shields, ect.
    var hasShield = (hasShield: false, turnsRemaining: 3)
    var isPoisoned = (isPoisoned: false, turnsRemaining: 4)
    
    
  //  var positionToMoveTo: CGPoint = CGPoint(x: 0, y: 0)
    
    var currentQuest: Quest? = nil
    var currentRoom: Vertex<RoomScene>? = nil
    var previousRoom: Vertex<RoomScene>? = nil
    
    //For if you're colliding with something, it is the direction opposite to the building
    //ShouldbeFacing is the direction you need to be facing to walk away from a collided building
    var directionShouldBeFacingIf: DirectionFacing = .other
    var oppositeDirection: DirectionFacing = .other
    
    var actionDoing: ActionDoing = .idling {
        didSet {
            if self.actionDoing == .idling {
                self.run(GameViewController.idleActions[self.directionFacing]!)
            }
        }
    }
    
    static var player: PlayerNode = PlayerNode()
    
    func updatePlayerStats() {
        //In other classes, events read/write directly to the GameData class, so this function pulls them into the players stats
         let saveFile = GameData.sharedInstance
        
        saveFile.save()
        
        self.level = saveFile.level
        self.exp = saveFile.exp
    }
    
    func movePlayer() {
        guard !(self.parent is BattleScene), self.actionDoing == .walking else { return }
            self.playerSpeed = self.isColliding ? 0 : 15
            
            //If player is collidng with a building, this will get run if they're facing away from the building so they can walk away from it.
            //TODO; make it so walking up and down the building is allowed
            
            if self.directionFacing == self.directionShouldBeFacingIf {
                self.playerSpeed = 15
            }
            //if player is colliding and not going approved direction, sets direction to other
            //This prevents clipping through walls.
            if self.isColliding && self.directionFacing != directionShouldBeFacingIf {
                self.directionFacing = .other
            }
            
            switch self.directionFacing {
            case .left:
                //self.run(GameViewController.walkLeft)
                self.directionShouldBeFacingIf = .right
                self.position.x -= playerSpeed
            case .right:
                //self.run(GameViewController.walkRight)
                self.directionShouldBeFacingIf = .left
                self.position.x += playerSpeed
            case .up:
                // self.run(GameViewController.walkUp)
                self.directionShouldBeFacingIf = .down
                self.position.y += playerSpeed
            case .down:
                //   self.run(GameViewController.walkDown)
                self.directionShouldBeFacingIf = .up
                self.position.y -= playerSpeed
            case .other:
                //     self.run(GameViewController.idleDown)
                self.position = self.position
            }
            self.isColliding = false
        
    }

    func configurePlayer() {
        self.size = CGSize(width: 330, height: 330)
        self.name = "player"
        self.texture = SKTexture(image: UIImage(named: "frontWalk00")!)
        self.zPosition = 2
        self.alpha = 1
        self.position = CGPoint(x: 0, y: -300)
    }
    
    func prepareForScene() {
        PlayerNode.player = self
        self.zPosition = 1
        self.removeAllActions()
        self.removeFromParent()
        self.actionDoing = .idling
        self.removeAllChildren()
    }
}
