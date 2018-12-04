//
//  AgendaCell.swift
//  timetable
//
//  Created by Juheb on 19/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import UIKit

class AgendaCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//

    //TODO: Navigate to event view when cell tapped
    func configureCell(event: RepeatingEvent){
        self.titleLabel.text = event.name
        
        
        switch event.priority {
        case 0:
            //default priority, colour set as in schedule
            setColour(text: UIColor(hex: event.colour), back: UIColor(hex: event.colour).withAlphaComponent(0.2))
        case 1:
            //med priority, black text, yellow back
            setColour(text: UIColor.black, back: UIColor.yellow)
        case 2:
            //high priority, white text, red back
            setColour(text: UIColor.white, back: UIColor.red)
        default:
            //black text, white back
            setColour(text: UIColor.black, back: UIColor.white)
        }
    }
    
    func setColour(text: UIColor, back: UIColor){
        titleLabel.textColor = text
        timeLabel.textColor = text
        backgroundColor = back
    }

}

