//
//  Queue.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 01/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import Foundation

public struct Queue<T: Hashable> {
    private var array: [T]
    
    public init() {
        array = []
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public func peek() -> T? {
        return array.first
    }
}
