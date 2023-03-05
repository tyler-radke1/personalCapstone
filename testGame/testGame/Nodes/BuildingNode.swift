//
//  BuildingNode.swift
//  testGame
//
//  Created by Tyler Radke on 2/15/23.
//

import UIKit
import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode {
    
    var isQuestTrigger = false
    
    func questTrigger() -> RoomScene? {
        if self.name == "questTrigger" {
            return RoomScene()
        } 
        return nil
    }
    
}
