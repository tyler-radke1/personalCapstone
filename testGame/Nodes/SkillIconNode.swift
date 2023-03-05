//
//  SkillIconNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/16/23.
//

import UIKit
import SpriteKit

class SkillIconNode: SKSpriteNode {
    
    static func configureIcons(icons: [SkillIconNode], player: PlayerNode) {
        //Configures skill icons. Currently there is only attack.
        
        let playerX = player.position.x
        let playerY = player.position.y + 300
        
        icons[0].position = CGPoint(x: playerX + 700, y: playerY - 230)
        
        
    }
    
    //Blank skill, to be edited later
    var skill: SkillProtocol = Attack()
   
}
