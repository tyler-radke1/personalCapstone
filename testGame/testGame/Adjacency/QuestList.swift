//
//  QuestList.swift
//  testGame
//
//  Created by Tyler Radke on 3/6/23.
//

import Foundation
import SpriteKit

class Quest {
    let quest = AdjacencyList<RoomScene>()
    
    private let room1 = RoomScene(fileNamed: "Room1")
    private let room2 = RoomScene(fileNamed: "Room2")
    private let room3 = RoomScene(fileNamed: "Room3")
    private let room4 = RoomScene(fileNamed: "Room4")
    private let room5 = RoomScene(fileNamed: "Room5")
    private let room6 =  RoomScene(fileNamed: "Room6")
    
    let rooms: [RoomScene]
    let roomsExitLeft: [RoomScene]
    let roomsExitRight: [RoomScene]
    let roomsExitUp: [RoomScene]
    let roomsExitDown: [RoomScene]
    
    init() {
        if let room1 = self.room1, let room2 = self.room2, let room3 = self.room3, let room4 = self.room4, let room5 = self.room5, let room6 = self.room6 {
            self.rooms = [room1,room2,room3,room4,room5,room6]
            self.roomsExitLeft = [room2, room3, room5, room6]
            self.roomsExitRight = [room1, room2, room4, room5]
            self.roomsExitUp = [room4, room5, room6]
            self.roomsExitDown = [room1, room2, room3]
        } else {
            self.rooms = []
            self.roomsExitLeft = []
            self.roomsExitRight = []
            self.roomsExitUp = []
            self.roomsExitDown = []
        }
    }
    
    func createGraph() {
        let firstRoom = rooms.randomElement()
        if let firstRoom = firstRoom {
            let _ = self.quest.createVertex(data: firstRoom)
        }
    }
    
}


