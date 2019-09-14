//
//  Visit.swift
//  GraphEditor
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 12/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import Foundation

public enum Visit<Element, U> where Element: Hashable, U: Hashable {

    case source

    case edge(Edge<Element, U>)
}
