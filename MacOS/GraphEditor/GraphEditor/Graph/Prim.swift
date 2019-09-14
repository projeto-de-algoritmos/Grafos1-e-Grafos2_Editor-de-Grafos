//
//  Prim.swift
//  GraphEditor
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 14/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import Foundation

class Prim<T: Hashable, U: Hashable> {
    typealias Graph = AdjacencyList<T, U>
    var priorityQueue = PriorityQueue<(vertex: Vertex<T>, weight: Double, parent: Vertex<T>?)>(sort: { $0.weight < $1.weight })

    func produceMinimumSpanningTree(graph: Graph) -> (cost: Double, mst: Graph) {
        var cost = 0.0
        let mst = Graph()
        var visited = Set<Vertex<T>>()

        guard let start = graph.getAllVertices().first else {
            return (cost: cost, mst: mst)
        }

        priorityQueue.enqueue((vertex: start, weight: 0.0, parent: nil))

        while let head = priorityQueue.dequeue() {
            let vertex = head.vertex
            if visited.contains(vertex) {
                continue
            }
            visited.insert(vertex)
            cost += head.weight

            if let prev = head.parent {
                mst.add(.undirected, from: prev, to: vertex, weight: head.weight)
            }

            if let neighbours = graph.edges(from: vertex) {
                for neighbour in neighbours {
                    if !visited.contains(neighbour.destination) {
                        priorityQueue.enqueue((vertex: neighbour.destination, weight: neighbour.weight ?? 0.0, parent: vertex))
                    }
                }
            }
        }

        return (cost: cost, mst: mst)
    }
}
