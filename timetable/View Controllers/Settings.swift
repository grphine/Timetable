//
//  SettingsViewController.swift
//  timetable
//
//  Created by Juheb on 03/12/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class Settings: UIViewController {
    

    //TODO: Add uiRealm.deleteAll() 
    //TODO: Allow user to switch between 12 and 24 hour time
    //TODO: Provide slider to select hours range
    
    @IBOutlet weak var formatSwitch: UISwitch!
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set switch default
    }
    
    @IBAction func rangeSliderChanged(_ sender: RangeSlider) {
        
        hoursLabel.text = "\(rangeSlider.lowerValue)hrs to \(rangeSlider.upperValue)hrs"
        
    }
    
    
    @IBAction func formatSwitchPressed(_ sender: UISwitch) {
        //update persistent storage
    }
   

    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        //delete all user data
        //popup alert warning first
    }
    
}
