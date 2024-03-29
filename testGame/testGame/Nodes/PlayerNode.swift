//
//  PlayerNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/13/23.
//

import UIKit
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
    var directionFacing: DirectionFacing = .other {
        didSet {
            switch self.directionFacing {
            case .left:
                self.oppositeDirection = .right
                self.run(Animations.walkLeft)
            case .right:
                self.oppositeDirection = .left
                self.run(Animations.walkRight)
            case .up:
                self.oppositeDirection = .down
                self.run(Animations.walkUp)
            case .down:
                self.oppositeDirection = .up
                self.run(Animations.walkDown)
            case .other:
                self.run(Animations.idleDown)
            }
        }
    }
   
    var playerSpeed: CGFloat = 15
    var isColliding = false
    var level = 1
    var health = 100
    //Health Formula based on level (x) - x/4 + (100 + x^2)
    
    //MARK: Status effect variables, such as stuns, heals, shields, ect.
    var hasShield = (hasShield: false, turnsRemaining: 3)
    
  //  var positionToMoveTo: CGPoint = CGPoint(x: 0, y: 0)
    
    var currentQuest: Quest? = nil
    var currentRoom: Vertex<RoomScene>? = nil
    var previousRoom: Vertex<RoomScene>? = nil
    
    //For if you're colliding with something, it is the direction opposite to the building
    //ShouldbeFacing is the direction you need to be facing to walk away from a collided building
    var directionShouldBeFacingIf: DirectionFacing = .other
    var oppositeDirection: DirectionFacing = .other
    
    var actionDoing: ActionDoing = .idling
    
    static var player: PlayerNode = PlayerNode()
    
    func movePlayer() {
        guard !(self.parent is BattleScene) else { return }
        
        //Whole function will be skipped if the player isn't walking (or running in future)
        guard self.actionDoing == .walking else { return }
       
        self.playerSpeed = self.isColliding ? 0 : 15
        
        //If player is collidng with a building, this will get run if they're facing away from the building so they can walk away from it.
        //TODO; make it so walking up and down the building is allowed
        if self.directionFacing == directionShouldBeFacingIf {
            self.playerSpeed = 15
        }
        
        //if player is colliding and not going approved direction, sets direction to other
        //This prevents clipping through walls.
        if self.isColliding && self.directionFacing != directionShouldBeFacingIf {
            self.directionFacing = .other
        }
        
        switch self.directionFacing {
        case .left:
            self.directionShouldBeFacingIf = .right
            self.position.x -= playerSpeed
        case .right:
            self.directionShouldBeFacingIf = .left
            self.position.x += playerSpeed
        case .up:
            self.directionShouldBeFacingIf = .down
            self.position.y += playerSpeed
        case .down:
            self.directionShouldBeFacingIf = .up
            self.position.y -= playerSpeed
        case .other:
            self.position = self.position
        }
        self.isColliding = false
    }

    func configurePlayer() {
        self.size = CGSize(width: 330, height: 330)
        self.name = "player"
        self.texture = SKTexture(imageNamed: "frontWalk00")
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
