//
//  QuestObject.swift
//  testGame
//
//  Created by Tyler Radke on 3/3/23.
//

import Foundation
import SpriteKit


struct Quest {
    var rooms: [RoomScene] = []
    
    var roomPlayerIsIn: RoomScene? = nil
    
    /// Generates Rooms
    /// - Parameter number: - Number of rooms to generate
    mutating func generateRooms(_ number: Int) {
        guard let room1 = Quest.room1, let room2 = Quest.room2, let room3 = Quest.room3 else { return }
        rooms.append(room1)
        
        rooms.append(room2)
        
        rooms.append(room3)
        roomPlayerIsIn = rooms[0]
    }
    
    static func initiateQuest() -> Quest {
        return Quest()
    }
    
    private static let room1 = RoomScene(fileNamed: "Room1")
    private static let room2 = RoomScene(fileNamed: "Room2")
    private static let room3 = RoomScene(fileNamed: "Room3")
    private static let room4 = RoomScene(fileNamed: "Room4")
    private static let room5 = RoomScene(fileNamed: "Room5")
    private static let room6 = RoomScene(fileNamed: "Room6")
    
}


class Node<T> {
    var value: T
    
    var children: [T] = []
    
    weak var parent: T?
    
    init(value: T) {
        self.value = value
    }
    
    func add(child: Node) {
        self.children.append(child)
    }
}
