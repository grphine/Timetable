//
//  Events.swift
//  timetable
//
//  Created by Juheb on 11/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import UIKit

public class EventItem {
    
    func nameFinder(column: Int, row: Int) -> String{ //function to get event name at that time
        var subject = ""
        for event in RepeatingEvents{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    subject = event.name
                }
            } //make clause for multiple items / ensure no conflicts
        }
        return subject
        
    }
    
    func colourFinder(column: Int, row: Int) -> UIColor{
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
    
    func descFinder(column: Int, row: Int) -> String{ //function to get event name at that time
        var desc = ""
        for event in RepeatingEvents{
            for rows in event.occurences[column-1]{
                if rows == row + 4{
                    desc = event.description
                }
            } //make clause for multiple items / ensure no conflicts
        }
        return desc
        
    }
    
    
}

public struct Event {
    
    var name: String
    var colour: UIColor //Swift doesn't handle hex well
    var occurences: [[Int]]
    var description: String
    //var reminder: Any
    
    init(name: String, colour: UIColor, occurences: [[Int]], description: String){
        self.name = name
        self.colour = colour
        self.occurences = occurences
        self.description = description
    }
}




