//
//  PriorityQueue.swift
//  GraphEditor
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 12/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import Foundation

public struct PriorityQueue<T> {

    fileprivate var heap: Heap<T>

    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(priorityFunction: sort)
    }

    public var isEmpty: Bool {
        return heap.isEmpty
    }

    public var count: Int {
        return heap.count
    }

    public func peek() -> T? {
        return heap.peek()
    }

    public mutating func enqueue(_ element: T) {
        heap.enqueue(element)
    }

    public mutating func dequeue() -> T? {
        return heap.dequeue()
    }
}
