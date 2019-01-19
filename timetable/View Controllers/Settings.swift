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
    
    var settings = SettingsStore()
    var lowerVal = Double()
    var upperVal = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = uiRealm.object(ofType: SettingsStore.self, forPrimaryKey: "1")!
        
        setupSlider(lower: settings.lowerBound, upper: settings.upperBound) //setup slider
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped)) //add save button
        
        lowerVal = rangeSlider.lowerValue
        upperVal = rangeSlider.upperValue
        
        if settings.twentyFour == true{
            formatSwitch.isOn = true
            setupLabel()
        }
        else {
            formatSwitch.isOn = false
            setupLabel()
        }
        // Do any additional setup after loading the view.
        
        //set switch default
    }
    
    @objc func saveTapped(){ //funtion called when save button tapped
        //update realm
        try! uiRealm.write { //update within a transaction
            
            settings.lowerBound = Int(rangeSlider.lowerValue)
            settings.upperBound = Int(rangeSlider.upperValue)
            if formatSwitch.isOn == true{
                settings.twentyFour = true
            } else { settings.twentyFour = false }
         
            uiRealm.add(settings, update: true)
        }
        
        print(settings)
        
    }
    
    @IBAction func rangeSliderChanged(_ sender: RangeSlider) {
        lowerVal = rangeSlider.lowerValue
        upperVal = rangeSlider.upperValue
        setupLabel()
    }
    
    
    @IBAction func formatSwitchPressed(_ sender: UISwitch) {
        //update persistent storage
        setupLabel()
    }
   

    @IBAction func deleteAllButtonPressed(_ sender: UIButton) {
        //delete all user data
        //popup alert warning first
    }
    
    func setupSlider(lower: Int, upper: Int){
        rangeSlider.lowerValue = Double(lower)
        rangeSlider.upperValue = Double(upper)
    }
    
    func convertToTwelve(time: Int) -> String{
        
        if time < 12{ //convert to am
            if time == 0{ //12am
                return "12am"
            } else { return "\(String(describing: time))am" } //1 - 11am
        }
        else {
            //convert to pm
            if time != 12{
                return "\(String(describing: time - 12))pm"
            } else { return "12pm" }
        }
    }
    
    func setupLabel(){
        if formatSwitch.isOn == true{ //setup settings switch and slider label
            var lowerText = ""
            if lowerVal < 12.0{
                lowerText = "0\(lowerVal)0"
            }
            else { lowerText = "\(lowerVal)0"}
            hoursLabel.text = "\(lowerText) to \(upperVal)0"
        }
        else {
            hoursLabel.text = "\(convertToTwelve(time: Int(lowerVal))) to \(convertToTwelve(time: Int(upperVal)))"
        }
    }
    
}
