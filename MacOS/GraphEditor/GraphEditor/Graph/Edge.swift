//
//  Edge.swift
//  Graph
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 28/08/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

enum EdgeType {
    case directed
    case undirected
}

public struct Edge<T: Hashable, U: Hashable> {
    var source: Vertex<T>
    var destination: Vertex<T>
    let weight: Double?
    let edgeNode: U
}

extension Edge: Hashable {

    public var hashValue: Int {
        return "\(source)\(destination)\(weight)".hashValue
    }

    static public func ==(lhs: Edge<T, U>, rhs: Edge<T, U>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}
