//
//  RealmSetupFile.swift
//  timetable
//
//  Created by Juheb on 12/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import RealmSwift

class NoteData: Object {
    
    @objc dynamic var id = ""
    
    @objc dynamic var title = ""
    @objc dynamic var age = ""
    @objc dynamic var body = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AllEvents: Object{
    
    let repeating = List<RepeatingEvent>()
    let single = List<SingleEvent>()
}

class SingleEvent: Object{
    
    @objc dynamic var name = ""
    @objc dynamic var colour = ""
    @objc dynamic var day = Date()
    @objc dynamic var time = Int()
    @objc dynamic var desc = ""
    @objc dynamic var priority = 3
}

class RepeatingEvent: Object{
    
    @objc dynamic var id = ""
    
    @objc dynamic var name = ""
    @objc dynamic var colour = ""
    let week = List<Day>() //collection of all the occurences of a repeating item in a week
    @objc dynamic var desc = ""
    @objc dynamic var priority = 3
    
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
