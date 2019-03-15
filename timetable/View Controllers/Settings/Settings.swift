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
        let repeating = uiRealm.objects(RepeatingEvent.self)
        let notes = uiRealm.objects(NoteData.self)
        
        //Setup alert
        let alert = UIAlertController(title: "Warning", message: "This action is not reversible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in //Delete event if user confirms
            try! uiRealm.write {
                uiRealm.delete(repeating)
                uiRealm.delete(notes)
            }
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func setupSlider(lower: Int, upper: Int){
        rangeSlider.lowerValue = Double(lower)
        rangeSlider.upperValue = Double(upper)
    }
    
    func setupLabel(){
        hoursLabel.text = "\(setupTimes(time: Int(lowerVal))) to \(setupTimes(time: Int(upperVal)))"
    }
    
    func setupTimes(time: Int) -> String{
        var string = ""
        
        if formatSwitch.isOn == true{
            //generate 24 hour times
            if time < 12{
                string = "0\(time):00"
            }
            else{
                string = "\(time):00"
            }
        }
        else{
            //generate 12 hour times
            if time < 12{
                if time == 0{
                    string = "12:00am"
                }
                else{
                    string = "\(time):00am"
                }
            }
            else{
                if time != 12{
                    string = "\(time-12):00pm"
                }
                else{ string = "12:00pm"}
            }
        }
        return string
    }
    
}
