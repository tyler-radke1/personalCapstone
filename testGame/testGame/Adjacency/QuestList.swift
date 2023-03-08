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
    
    static let room1 = RoomScene(fileNamed: "Room1")
    static let room2 = RoomScene(fileNamed: "Room2")
    static let room3 = RoomScene(fileNamed: "Room3")
    static let room4 = RoomScene(fileNamed: "Room4")
    static let room5 = RoomScene(fileNamed: "Room5")
    static let room6 =  RoomScene(fileNamed: "Room6")
    
    static let rooms = [room1,room2,room3,room4,room5,room6]
    static let roomsExitLeft = [room2, room3, room5, room6]
    static let roomsExitRight = [room1, room2, room4, room5]
    static let roomsExitUp = [room4, room5, room6]
    static let roomsExitDown = [room1, room2, room3]
    
    func createGraph() {
            Quest.room1?.roomType = .upperLeft
            Quest.room2?.roomType = .forkDown
            Quest.room3?.roomType = .upperRight
            Quest.room4?.roomType = .lowerLeft
            Quest.room5?.roomType = .forkUp
            Quest.room6?.roomType = .lowerRight
        
        let firstRoom = Quest.room1
        
        let vertex = self.quest.createVertex(data: firstRoom!)
        }
        
        
        /*
         let vertex1: Vertex<RoomScene> = quest.createVertex(data: room1!)
         let vertex2: Vertex<RoomScene> = quest.createVertex(data: room2!)
         let vertex3: Vertex<RoomScene> = quest.createVertex(data: room3!)
         let vertex4: Vertex<RoomScene> = quest.createVertex(data: room4!)
         let vertex5: Vertex<RoomScene> = quest.createVertex(data: room5!)
         let vertex6: Vertex<RoomScene> = quest.createVertex(data: room6!)
         
         //Connections for Room 1. All connections ordered right, down, left, up
         quest.addUndirectedEdge(between: vertex1, and: vertex2)
         quest.addUndirectedEdge(between: vertex1, and: vertex4)
         
         //Room 2
         quest.addUndirectedEdge(between: vertex2, and: vertex3)
         quest.addUndirectedEdge(between: vertex2, and: vertex5)
         
         
         //Room 3
         quest.addUndirectedEdge(between: vertex3, and: vertex6)
         
         
         //Room 4
         quest.addUndirectedEdge(between: vertex4, and: vertex5)
         
         
         //Room 5
         quest.addUndirectedEdge(between: vertex5, and: vertex6)
         //Room 6
         */
    }

