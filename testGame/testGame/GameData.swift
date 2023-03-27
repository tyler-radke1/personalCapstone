//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 3/27/23.
//

import Foundation
import SpriteKit

enum SaveGameKeys: String {
    case exp = "exp"
    case level = "level"
}

class GameData: NSObject, NSCoding {
    required init?(coder: NSCoder) {
        
    }
    
    var exp = 0
    var level = 1
    
    func encode(with coder: NSCoder) {
        coder.encode(exp, forKey: SaveGameKeys.exp.rawValue)
        coder.encode(level, forKey: SaveGameKeys.level.rawValue)
    }
    
}
