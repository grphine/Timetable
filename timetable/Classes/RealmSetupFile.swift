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
    @objc dynamic var age = Date()
    @objc dynamic var body = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Event: Object{
    
    @objc dynamic var name = ""
    @objc dynamic var colour = UIColor() //Swift doesn't handle hex well
    @objc dynamic var occurences = [[Int]]()
    @objc dynamic var desc = ""
    @objc dynamic var priority = 3
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}

class EventData: Event{
    
    //MARK: nameByCell
    func nameByCell(array: [Event], column: Int, row: Int) -> String{ //get event name by cell
            var subject = ""
            for event in array{
                for rows in event.occurences[column-1]{
                    if rows == row + 4{
                        subject = event.name
                    }
                }
            }
            return subject
    
        }
    
    //MARK: colourByCell
    func colourByCell(array: [Event], column: Int, row: Int) -> UIColor{ //get event colour by cell
        var colour = UIColor()
        for event in array{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    colour = event.colour
                }
            }
        }
        return colour

    }

    //MARK: descByCell
    func descByCell(array: [Event], column: Int, row: Int) -> String{ //get event description by cell
        var desc = ""
        for event in array{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    desc = event.description
                }
            }
        }
        return desc

    }

    //MARK: eventByCell
    func eventByCell(array: [Event], column: Int, row: Int) -> Event{ //get event by cell
        var event = Event()
        for item in array{
            for rows in item.occurences[column-1]{
                if rows == row + 4{
                    event = item
                }
            }
        }
        return event
    }

    //MARK: eventByName
    func eventByName(array: [Event], name: String) -> Event { //get event by event name
        var event = Event()
        for item in array{
            if item.name == name{
                event = item
            }
        }
        return event
    }
    
    
}



extension Results {
    func toArray() -> [Any] { //put items into an array
        return self.map{$0}
    }
    
    func toEvent(event: Event, name: String, colour: UIColor, occurences: [[Int]], description: String, priority: Int) -> Event{ //create/modify an event
        event.name = name
        event.colour = colour
        event.occurences = occurences
        event.desc = description
        event.priority = priority
        
        return event
    }
    
}

extension RealmSwift.List {
    func toArray() -> [Any] {
        return self.map{$0}
    }
}
