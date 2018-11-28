//
//  Data.swift
//  collapsible tableview
//
//  Created by Juheb on 28/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation

public struct Section {
    var name: String
    var items: [Int]
    var selected: [Int]
    var collapsed: Bool
    
    public init(name: String, items: [Int], selected: [Int], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.selected = selected
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(name: "Monday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Tuesday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Wednesday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Thursday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Friday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Saturday", items: [9,10,11,12,13,14,15], selected: []),
    Section(name: "Sunday", items: [9,10,11,12,13,14,15], selected: []),
]

