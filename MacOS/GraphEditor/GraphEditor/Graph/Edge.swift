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

struct Edge<T: Hashable> {
    var source: Vertex<T>
    var destination: Vertex<T>
    let weight: Double?
}

extension Edge: Hashable {

    public var hashValue: Int {
        return "\(source)\(destination)\(weight)".hashValue
    }

    static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}
