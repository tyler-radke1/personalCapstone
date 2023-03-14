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
        var newScene = RoomScene()
        newScene = rooms.randomElement()!
        let newVertex = quest.createVertex(data: newScene)
        generateDungeon(count: 0)
    }
    
    func generateDungeon(count: Int) {
        print("Loop number: \(count)")
        let rooms = quest.adjacencies.keys
        guard count <= 5, quest.adjacencies.keys.count <= 20 else { return }
        for room in rooms {
            var arrays: [[RoomScene]] = []
            var edges = quest.edges(from: room)
            //loops through all destinations from room, checks each exit direction
            switch room.data.roomType {
                //for each room type, it sets the arrays variable to which directions it needs to check for
            case .upperLeft:
                //If edges does not contain an edge where roomsExitLeft contains it's destination point.
                arrays = [roomsExitLeft, roomsExitUp]
            case .forkDown:
                arrays = [roomsExitLeft, roomsExitRight, roomsExitUp]
            case .upperRight:
                arrays = [roomsExitRight, roomsExitUp]
            case .lowerLeft:
                arrays = [roomsExitDown, roomsExitLeft]
            case .forkUp:
                arrays = [roomsExitLeft, roomsExitRight, roomsExitDown]
            case .lowerRight:
                arrays = [roomsExitRight, roomsExitDown]
            default:
                print("hello world")
            }
            
            for array in arrays {
                edges = quest.edges(from: room)
                guard edges.count > 0 else {
                    var newScene = RoomScene()
                    newScene = array.randomElement()!
                    let newVertex = quest.createVertex(data: newScene)
                    quest.addUndirectedEdge(between: room, and: newVertex)
                    continue
                }
                
                for edge in edges {
                    if !(array.contains(edge.destination.data)) {
                        var newScene = RoomScene()
                        newScene = array.randomElement()!
                        let newVertex = quest.createVertex(data: newScene)
                        quest.addUndirectedEdge(between: room, and: newVertex)
                    }
                }
            }
           
            
            print("Generated \(quest.adjacencies.keys.count) rooms")
            generateDungeon(count: count + 1)
        }
    }
}
