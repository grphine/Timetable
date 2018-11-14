//
//  Events.swift
//  timetable
//
//  Created by Juheb on 11/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import UIKit

//MARK: Event class
public class Event {
    
    //MARK: nameByCell
    func nameByCell(column: Int, row: Int) -> String{ //get event name by cell
        var subject = ""
        for event in RepeatingEvents{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    subject = event.name
                }
            }
        }
        return subject
        
    }
    
    //MARK: colourByCell
    func colourByCell(column: Int, row: Int) -> UIColor{ //get event colour by cell
        var colour = UIColor()
        for event in RepeatingEvents{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    colour = event.colour
                }
            }
        }
        return colour
        
    }
    
    //MARK: descByCell
    func descByCell(column: Int, row: Int) -> String{ //get event description by cell
        var desc = ""
        for event in RepeatingEvents{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    desc = event.description
                }
            }
        }
        return desc
        
    }
    
    //MARK: eventByCell
    func eventByCell(column: Int, row: Int) -> [EventItem]{ //get event by cell
        var event = [EventItem]()
        for item in RepeatingEvents{
            for rows in item.occurences[column-1]{
                if rows == row + 4{
                    event = [item]
                }
            }
        }
        return event
    }
    
    //MARK: eventByName
    func eventByName(name: String) -> [EventItem] {
        var event = [EventItem]()
        for item in RepeatingEvents{
            if item.name == name{
                event = [item]
            }
        }
        return event
    }
    
    
}

//MARK: EventItem struct
public struct EventItem {
    
    var name: String
    var colour: UIColor //Swift doesn't handle hex well
    var occurences: [[Int]]
    var description: String
    var priority: Int
    //var reminder: Any
    
    init(name: String, colour: UIColor, occurences: [[Int]], description: String, priority: Int){
        self.name = name
        self.colour = colour
        self.occurences = occurences
        self.description = description
        self.priority = priority
    }
}




