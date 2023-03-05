//
//  CameraNode Extension.swift
//  testGame
//
//  Created by Tyler Radke on 2/16/23.
//

import Foundation
import SpriteKit

extension SKCameraNode {
    func configureCamera(around player: PlayerNode) {
        self.position.x = PlayerNode.player.position.x
        self.position.y = PlayerNode.player.position.y + 350
    }
    
    
    
}
