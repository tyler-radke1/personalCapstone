//
//  GameViewController.swift
//  testGame
//
//  Created by Tyler Radke on 2/13/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController {
    
    //Walking Animations
    static let walkDown = (SKAction(named: "walkFront")!)
    static let walkUp = (SKAction(named: "walkBack")!)
    static let walkLeft = (SKAction(named: "walkLeft")!)
    static let walkRight = (SKAction(named: "walkRight")!)
    
    //private let walks = [walkLeft, walkRight, walkDown, walkUp]
    
    //Idling Animations
    static let idleDown = SKAction.repeatForever(SKAction(named: "idleDown")!)
    static let idleLeft = SKAction.repeatForever(SKAction(named: "idleLeft")!)
    static let idleRight = SKAction.repeatForever(SKAction(named: "idleRight")!)
    static let idleUp = SKAction.repeatForever(SKAction(named: "idleUp")!)
    
    
    //Attacking Animations
    static let attackRight = SKAction.repeat(SKAction(named: "attackRight", duration: 0.5)!, count: 1)
    
    
    //Damage taken animations
    static let hurtRight =  SKAction.repeat(SKAction(named: "hurtRight", duration: 0.5)!, count: 1)
    
    static func configureAnimation(action: ActionDoing, direction: DirectionFacing) -> SKAction {

        if action == .idling {
            switch direction {
            case .up:
                return GameViewController.idleUp
            case .down:
                return GameViewController.idleDown
            case .left:
                return GameViewController.idleLeft
            case .right:
                return GameViewController.idleRight
            case .other:
                return GameViewController.idleDown

            }

        }

        if action == .walking {
            switch direction {
            case .up:
                return GameViewController.walkUp
            case .down:
                return GameViewController.walkDown
            case .left:
                return GameViewController.walkLeft
            case .right:
                return GameViewController.walkRight
            case .other:
                return GameViewController.walkDown

            }

        }

        return GameViewController.walkDown
    }
    
}
