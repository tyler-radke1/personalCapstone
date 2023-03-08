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
    
    let room1 = RoomScene(fileNamed: "Room1")
    let room2 = RoomScene(fileNamed: "Room2")
    let room3 = RoomScene(fileNamed: "Room3")
    let room4 = RoomScene(fileNamed: "Room4")
    let room5 = RoomScene(fileNamed: "Room5")
    let room6 =  RoomScene(fileNamed: "Room6")
    
    
    
    func createGraph() {
        guard let room1 = room1, let room2 = room2, let room3 = room3, let room4 = room4, let room5 = room5, let room6 = room6 else { return }
        
        room1.roomType = .upperLeft
        room2.roomType = .forkDown
        room3.roomType = .upperRight
        room4.roomType = .lowerLeft
        room5.roomType = .forkUp
        room6.roomType = .lowerRight
        let rooms = [room1,room2,room3,room4,room5,room6]
        let roomsEnterLeft = [room2, room3, room5, room6]
        let roomsEnterRight = [room1, room2, room4, room5]
        let roomsEnterUp = [room4, room5, room6]
        let roomsEnterBottom = [room1, room2, room3]
        
        /// Generates Rooms
        /// - Parameter vertex: Vertex to add rooms around.
        /// Each room type has endpoints that can only correspond to certain start points. For example, the upper left corner room type has an upper and right exit point. This means that each point can only pair up with rooms that have a bottom or left exit point, respectively.
        ///
        /// This function loops over the edges for a given vertex and checks the currently existing destinations room types. Based on this knowledge, it adds any missing rooms.
        ///
        /// Take as an example, an upper left corner than has a room exiting to the top, but not a room exiting to the right.
        ///
        /// It will find that there is one edge destination. The roomsEnteringLeft check will fail, and it will run the else block, which adds a vertex
        func generateRooms(vertex: Vertex<RoomScene>? = nil) {
            guard quest.adjacencies.keys.count < 10 else { return }
            guard let vertex = vertex else { return }
            
            /* let edges = quest.edges(from: vertex)
             for edge in edges {
             switch vertex.data.roomType {
             case .upperLeft:
             if roomsEnterLeft.contains(edge.destination.data) {
             let upperVertex = quest.createVertex(data: roomsEnterBottom.randomElement()!)
             quest.addUndirectedEdge(between: vertex, and: upperVertex)
             } else {
             let rightVertex = quest.createVertex(data: roomsEnterLeft.randomElement()!)
             quest.addUndirectedEdge(between: vertex, and: rightVertex)
             }
             
             case .forkDown:
             if roomsEnterRight.contains(edge.destination.data) {
             let bottomVertex = quest.createVertex(data: roomsEnterUp.randomElement()!)
             let rightVertex = quest.createVertex(data: roomsEnterLeft.randomElement()!)
             
             quest.addUndirectedEdge(between: vertex, and: bottomVertex)
             quest.addUndirectedEdge(between: vertex, and: rightVertex)
             } else if roomsEnterLeft.contains(edge.destination.data) {
             let bottomVertex = quest.createVertex(data: roomsEnterUp.randomElement()!)
             let leftVertex = quest.createVertex(data: roomsEnterRight.randomElement()!)
             
             quest.addUndirectedEdge(between: vertex, and: bottomVertex)
             quest.addUndirectedEdge(between: vertex, and: leftVertex)
             } else if roomsEnterUp.contains(edge.destination.data) {
             let rightVertex = quest.createVertex(data: roomsEnterLeft.randomElement()!)
             let leftVertex = quest.createVertex(data: roomsEnterRight.randomElement()!)
             
             quest.addUndirectedEdge(between: vertex, and: rightVertex)
             quest.addUndirectedEdge(between: vertex, and: leftVertex)
             }
             default:
             print("Hello world")
             }
             
             */
            
            switch vertex.data.roomType {
            case .upperLeft:
                let rightRoom = roomsEnterLeft.randomElement()
                let rightVertex = quest.createVertex(data: rightRoom!)
                quest.addUndirectedEdge(between: vertex, and: rightVertex)
                generateRooms(vertex: rightVertex)
                
                let bottomRoom = roomsEnterBottom.randomElement()
                let bottomVertex = quest.createVertex(data: bottomRoom!)
                quest.addUndirectedEdge(between: vertex, and: bottomVertex)
                generateRooms(vertex: bottomVertex)
            default:
                print("hello world")
            }
            
        }
        
        let initialVertex = quest.createVertex(data: room1)
        
        generateRooms(vertex: initialVertex)
        print(quest.description)
        
        
        //        let vertex1: Vertex<RoomScene> = quest.createVertex(data: room1!)
        //        let vertex2: Vertex<RoomScene> = quest.createVertex(data: room2!)
        //        let vertex3: Vertex<RoomScene> = quest.createVertex(data: room3!)
        //        let vertex4: Vertex<RoomScene> = quest.createVertex(data: room4!)
        //        let vertex5: Vertex<RoomScene> = quest.createVertex(data: room5!)
        //        let vertex6: Vertex<RoomScene> = quest.createVertex(data: room6!)
        //
        //        //Connections for Room 1. All connections ordered right, down, left, up
        //        quest.addUndirectedEdge(between: vertex1, and: vertex2)
        //        quest.addUndirectedEdge(between: vertex1, and: vertex4)
        //
        //        //Room 2
        //        quest.addUndirectedEdge(between: vertex2, and: vertex3)
        //        quest.addUndirectedEdge(between: vertex2, and: vertex5)
        //
        //
        //        //Room 3
        //        quest.addUndirectedEdge(between: vertex3, and: vertex6)
        //
        //
        //        //Room 4
        //        quest.addUndirectedEdge(between: vertex4, and: vertex5)
        //
        //
        //        //Room 5
        //        quest.addUndirectedEdge(between: vertex5, and: vertex6)
        //        //Room 6
    }
    
    
}

