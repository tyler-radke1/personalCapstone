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
        var rooms = [room1,room2,room3,room4,room5,room6]
        
        let initialVertex = quest.createVertex(data: room1)
        
        func generateRooms(vertex: Vertex<RoomScene>? = nil) {
            guard let vertex = vertex else { return }
            
            switch vertex.data.roomType {
            case .upperLeft:
                let rightRoom = [room2, room3, room5, room6].randomElement()
                let rightVertex = quest.createVertex(data: rightRoom!)
                
                let bottomRoom = [room4, room5, room6].randomElement()
                let bottomVertex = quest.createVertex(data: bottomRoom!)
                
            default:
                print("Hello world")
        
            }
        }
        
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








