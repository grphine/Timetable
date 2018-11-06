//
//  Agenda.swift
//  timetable
//
//  Created by Juheb on 30/10/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class Agenda: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        
    }
    
   
        


}

