//
//  Animations.swift
//  testGame
//
//  Created by Tyler Radke on 2/14/23.
//

import Foundation
import SpriteKit

struct Animations {
    
    //Walking Animations
    static let walkDown = SKAction.repeatForever(SKAction(named: "walkFront")!)
    static let walkUp = SKAction.repeatForever(SKAction(named: "walkBack")!)
    static let walkLeft = SKAction.repeatForever(SKAction(named: "walkLeft")!)
    static let walkRight = SKAction.repeatForever(SKAction(named: "walkRight")!)
    
    private let walks = [walkLeft, walkRight, walkDown, walkUp]
    
    //Idling Animations
    static let idleDown = SKAction.repeatForever(SKAction(named: "idleDown")!)
    static let idleLeft = SKAction.repeatForever(SKAction(named: "idleLeft")!)
    static let idleRight = SKAction.repeatForever(SKAction(named: "idleRight")!)
    static let idleUp = SKAction.repeatForever(SKAction(named: "idleUp")!)
    
    
    //Attacking Animations
    static let attackRight = SKAction.repeat(SKAction(named: "attackRight", duration: 0.5)!, count: 1)
    
    
    //Damage taken animations
    static let hurtRight =  SKAction.repeat(SKAction(named: "hurtRight", duration: 0.5)!, count: 1)
    
    
}

extension Animations {
    //For configuring animations
    
    static func configureAnimation(action: ActionDoing, direction: DirectionFacing) -> SKAction {
        
        if action == .idling {
            switch direction {
            case .up:
                return Animations.idleUp
            case .down:
                return Animations.idleDown
            case .left:
                return Animations.idleLeft
            case .right:
                return Animations.idleRight
            case .other:
                return Animations.idleDown

            }
            
        }
        
        if action == .walking {
            switch direction {
            case .up:
                return Animations.walkUp
            case .down:
                return Animations.walkDown
            case .left:
                return Animations.walkLeft
            case .right:
                return Animations.walkRight
            case .other:
                return Animations.walkDown

            }
            
        }
        
//        if action == .attacking {
//            return Animations.attackRight
//        }
        
        return Animations.walkDown
    }
}
