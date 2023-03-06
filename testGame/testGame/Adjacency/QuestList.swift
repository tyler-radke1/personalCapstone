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
    
    let rooms = [room1, room2, room3, room4, room5, room6]
    
    func createGraph() {
        let vertex1: Vertex<RoomScene> = quest.createVertex(data: Quest.room1!)
        let vertex2: Vertex<RoomScene> = quest.createVertex(data: Quest.room2!)
        let vertex3: Vertex<RoomScene> = quest.createVertex(data: Quest.room3!)
        let vertex4: Vertex<RoomScene> = quest.createVertex(data: Quest.room4!)
        let vertex5: Vertex<RoomScene> = quest.createVertex(data: Quest.room5!)
        let vertex6: Vertex<RoomScene> = quest.createVertex(data: Quest.room6!)
        
        //Connections for Room 1. All connections ordered right, down, left, up
        quest.addUndirectedEdge(between: vertex1, and: vertex2)
        quest.addUndirectedEdge(between: vertex1, and: vertex4)
        
        //Room 2
        quest.addUndirectedEdge(between: vertex2, and: vertex3)
        quest.addUndirectedEdge(between: vertex2, and: vertex5)
        quest.addUndirectedEdge(between: vertex2, and: vertex1)
        
        
        //Room 3
        quest.addUndirectedEdge(between: vertex3, and: vertex6)
        quest.addUndirectedEdge(between: vertex3, and: vertex2)
        
        
        //Room 4
        quest.addUndirectedEdge(between: vertex4, and: vertex5)
        quest.addUndirectedEdge(between: vertex4, and: vertex1)
        
        
        //Room 5
        quest.addUndirectedEdge(between: vertex5, and: vertex6)
        quest.addUndirectedEdge(between: vertex5, and: vertex4)
        quest.addUndirectedEdge(between: vertex5, and: vertex2)
        //Room 6
    }
}








