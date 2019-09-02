//
//  Stack.swift
//  GraphEditor
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 31/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

public struct Stack<T: Hashable> {
    fileprivate var array: [T] = []

    public init() {}

    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }

    public func peek() -> T? {
        return array.last
    }

    public func lastMinusOne() -> T? {
        guard array.count > 1 else { return nil }

        return array[array.count - 2]
    }

    public func contains(_ element: T) -> Bool {
        for _element in array {
            if _element == element {
                return true
            }
        }

        return false

    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n-----------\n"

        let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
}
