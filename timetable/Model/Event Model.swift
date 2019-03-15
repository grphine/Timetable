//
//  Event Model.swift
//  timetable
//
//  Created by Juheb on 14/03/2019.
//  Copyright © 2019 Juheb. All rights reserved.
//

import Foundation
import RealmSwift


class RepeatingEvent: Object{
    
    @objc dynamic var id = ""
    
    @objc dynamic var name = ""
    @objc dynamic var colour = ""
    let week = List<Day>() //collection of all the occurences of a repeating item in a week
    @objc dynamic var desc = ""
    @objc dynamic var priority = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class Day: Object { //the column the event appears in
    let dayItem = List<Hour>()
}

class Hour: Object { //the row the event appears in
    @objc dynamic var hourItem = Int()
}

extension Results {
    func toArray() -> [Any] { //put items into an array
        return self.map{$0}
    }
    
}

extension RealmSwift.List {
    func toArray() -> [Any] {
        return self.map{$0}
    }
}
