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
}

extension Stack: CustomStringConvertible {
    public var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n-----------\n"

        let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
}
