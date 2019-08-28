//
//  Graphable.swift
//  Graph
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 28/08/19.
//  Copyright © 2019 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import Foundation

protocol Graphable {
    associatedtype Element: Hashable

    var description: CustomStringConvertible { get }

    func createVertex(data: Element) -> Vertex<Element>
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
    func edges(from source: Vertex<Element>) -> [Edge<Element>]?

}
