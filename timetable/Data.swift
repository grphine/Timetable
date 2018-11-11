//
//  Data.swift
//  Pods-timetable
//
//  Created by Juheb on 11/11/2018.
//

public var RepeatingEvents = ["Maths": [0x778BCD, ["M": [9, 12, 13], "Tu": [9]], "Maths lessons", "reminders"], "English": [0xF2F16F, ["M": [10, 14, 15], "Tu": [10]], "English lessons", "reminders"]]

public var SingleEvents = ["dd/MM/yyyy": ["subject/name", "time", "colour", "description", "reminders"]]



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
