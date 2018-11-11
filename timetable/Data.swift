//
//  Data.swift
//  Pods-timetable
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

public var SingleEvents = ["dd/MM/yyyy": ["subject/name", "time", "colour", "description", "reminders"]]

public var RepeatingEvents: [Event] = []



//func add(){
//let maths = Event(name: "Maths", colour: 0xF2F16F, occurences: [[9, 12, 13],[9],[1],[3],[4,12,5,4],[],[]], description: "maths lesson")
//let english = Event(name: "English", colour: 0xF2F16F, occurences: [[10,11],[10],[2],[4],[1],[],[]], description: "english lesson")
//
//RepeatingEvents.append(maths)
//RepeatingEvents.append(english)
//}


/* array of dictionaries, for each item
this is for recurring items
 
 [  {subject/name: [hex colour, [{day: [times]}], description, reminders] } ]
 
 */


/*
 
 let dateString = "25/01/2011"
 
 let dateFormatter = DateFormatter()
 
 dateFormatter.dateFormat = "dd/MM/yyyy"
 
 let dateFromString = dateFormatter.date(from: dateString)
 
 */
