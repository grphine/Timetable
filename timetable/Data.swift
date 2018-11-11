//
//  Data.swift
//  Pods-timetable
//
//  Created by Juheb on 11/11/2018.
//

public var RepeatingEvents = ["Maths": [0x778BCD, [1: [9, 12, 13], 2: [9]], "Maths lessons", "reminders"], "English": [0xF2F16F, [1: [10, 14, 15], 2: [10]], "English lessons", "reminders"]]

public var SingleEvents = ["dd/MM/yyyy": ["subject/name", "time", "colour", "description", "reminders"]]

var Hours = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]



struct Event { //struct to create events for timetable
    
    var name: String
    var colour: Int
    var occurences: [Int: [Int]]
    var description: String
    //var reminder: Any
    
    init(name: String, colour: Int, occurences: [Int: [Int]], description: String){
        self.name = name
        self.colour = colour
        self.occurences = occurences
        self.description = description
    }
}



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
