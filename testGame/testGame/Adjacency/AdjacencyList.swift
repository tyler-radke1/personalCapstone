//
//  QuestObject.swift
//  testGame
//
//  Created by Tyler Radke on 3/3/23.
//

import Foundation
import SpriteKit


enum EdgeType {
    case directed
    case undirected
}

struct Vertex<T> {
    let data: T
    private var roomEnemies: [EnemyNode] = []
    var index: Int
    var roomCleared = false
    
    init(data: T, index: Int, roomCleared: Bool = false) {
        self.data = data
        self.roomEnemies = []
        self.index = index
        self.roomCleared = roomCleared
    }
    mutating func generateEnemies(player: PlayerNode)  {
        guard self.roomEnemies.count == 0, roomCleared == false else { return }
        for _ in 1...5 {
            let enemy: EnemyNode = EnemyNode()
            enemy.configureEnemy()
            roomEnemies.append(enemy)
        }
    }
    
    func addEnemies(scene: SKScene) {
        self.roomEnemies.forEach({ node in
            scene.addChild(node)
        })
    }
    mutating func removeEnemies(with id: UUID) {
        roomEnemies.removeAll(where: { $0.enemyID == id})
        //sets room cleared to true if you defeat all enemies, stops spawn
        roomCleared = (roomEnemies.count != 0) ? true : false
    }
}

struct Edge<T> {
    var source: Vertex<T>
    var destination: Vertex<T>
}

extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "\(index):\(data)"
    }
}

protocol Graph {
    associatedtype Element
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>)
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
}


class AdjacencyList <T: Hashable>: Graph {
    typealias Element = T
    var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    
    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, index: adjacencies.count)
        adjacencies[vertex] = []
        return vertex
    }
    
    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>) {
        let edge = Edge(source: source, destination: destination)
        adjacencies[source]?.append(edge)
    }
    
    func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>) {
        addDirectedEdge(from: source, to: destination)
        addDirectedEdge(from: destination, to: source)
    }
    
    func add(_ edge: EdgeType, from source: Vertex<T>, to destination: Vertex<T>) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination)
        case .undirected:
            addUndirectedEdge(between: source, and: destination)
        }
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }
}

extension AdjacencyList: CustomStringConvertible {
    public var description: String {
            var result = ""
        for (vertex, edges) in adjacencies { // 1
                var edgeString = ""
                for (index, edge) in edges.enumerated() { // 2
                    if index != edges.count - 1 {
                        edgeString.append("\(edge.destination), ")
                    } else {
                        edgeString.append("\(edge.destination)")
                    }
                }
                result.append("\(vertex) ---> [ \(edgeString) ]\n") // 3
            }
            return result
        }
}
