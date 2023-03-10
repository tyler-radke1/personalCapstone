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
            
            room1.roomType = .upperLeft
            room2.roomType = .forkDown
            room3.roomType = .upperRight
            room4.roomType = .lowerLeft
            room5.roomType = .forkUp
            room6.roomType = .lowerRight
            
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
    
    func generateDungeon() {
        guard !(quest.adjacencies.isEmpty) else {
            let initialRoom = rooms.randomElement()
            
            if let initialRoom {
                self.quest.createVertex(data: initialRoom)
            }
            return
        }
        
        var rooms = quest.adjacencies.keys
        
        for room in rooms {
            let edges = quest.edges(from: room)
            let destinations = edges.map { $0.destination }
            //loops through all destinations from room, checks each exit direction
            switch room.data.roomType {
            case .upperLeft:
                if !edges.contains(where: { edgeRoom in
                    roomsExitLeft.contains(edgeRoom.destination.data)
                }) {
                    let newVertex = quest.createVertex(data: roomsExitLeft.randomElement()!)
                    quest.addUndirectedEdge(between: room, and: newVertex)
                } else if !edges.contains(where: { edgeRoom in
                    roomsExitUp.contains(edgeRoom.destination.data)
                }) {
                    let newVertex = quest.createVertex(data: roomsExitUp.randomElement()!)
                    quest.addUndirectedEdge(between: room, and: newVertex)
                }
                
            default:
                print("hello world")
            }
            
        }
    }
    
    private func generateSingleRoom(roomOptions: [RoomScene], from initalRoom: Vertex<RoomScene>) {
        
    }
}
