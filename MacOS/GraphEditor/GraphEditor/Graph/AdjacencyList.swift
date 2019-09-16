//
//  AdjacencyList.swift
//  Graph
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 28/08/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

class AdjacencyList<T: Hashable> {
    var adjacencyDict: [Vertex<T>: [Edge<T>]] = [:]
    public init() { }

    fileprivate func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        if adjacencyDict[source] == nil {
            adjacencyDict[source] = []
        }
        adjacencyDict[source]!.append(edge)
    }

    public func getAllVertices() -> [Vertex<T>] {
        return Array(adjacencyDict.keys)
    }

    fileprivate func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), weight: Double?) {
        let (source, destination) = vertices
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

}

extension AdjacencyList: Graphable {
    public typealias Element = T
    
    var description: CustomStringConvertible {
        var result = " "
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }
    
    func reset() {
        adjacencyDict.removeAll()
    }
    
    func deleteEdge(between vertex1: Vertex<Element>, and vertex2: Vertex<Element>) {
        adjacencyDict[vertex1]?.removeAll(where: { (edge) -> Bool in
            return edge.destination == vertex2
        })
        adjacencyDict[vertex2]?.removeAll(where: { (edge) -> Bool in
            return edge.destination == vertex1
        })
    }

    func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data: data)

        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }

        return vertex
    }

    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {

        switch type {

        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }

    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {

        guard let edges = adjacencyDict[source] else { return nil }

        for edge in edges {
            if edge.destination == destination {
                return edge.weight
            }
        }

        return nil
    }

    func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyDict[source]
    }

    func edges() -> [Edge<Element>] {
        var allEdges = [Edge<Element>]()
        for edgeArray in adjacencyDict.values {
            allEdges.append(contentsOf: edgeArray)
        }
        return allEdges
    }
}
