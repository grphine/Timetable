//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController {
    
    var event = Event()
    var name = String()
    var columnRow: [Int]!
    var eventItem = [EventItem]()
    var check = 0 //for edit button
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var priorityLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //name = event.nameByCell(column: columnRow[0], row: columnRow[1])
        
        eventItem = event.eventByCell(column: columnRow[0], row: columnRow[1])
        
        if eventItem.isEmpty == true {
            print("empty")
            //edit button unlocked automatically
        }
        else{
            name = eventItem[0].name //since it is cast into an array. Not sure how to pull the event otherwise
            nameLabel.text = name
            descriptionLabel.text = eventItem[0].description
            priorityLabel.text = String(describing: eventItem[0].priority)
            dateLabel.text = String(describing: eventItem[0].occurences)
        }
        
        //print(columnRow as [Int])
        
        //let maths = EventItem(name: "Maths", colour: UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1), occurences: [[11,12],[11],[13],[],[],[14],[14]], description: "maths lesson")

        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        
        /*case (item conflict){
            store where the conflict was found and output as popup
         case (item out of range)
            output error. Also check inputs dynamically maybe?
         case (repeat event)
            tell user to tap on event in ssv and edit
        */
        
        //if all good:
        
        //delete current data and append new data
        
        //new struct initialisation for adding new event
        
        //send alerts of data being updated
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool){
        
        super.setEditing(editing, animated: animated)
        if check % 2 == 0{
            //if check is even, user interaction enabled
            //patientID.isUserInteractionEnabled = true
            //put all fields into an array and set them all, potentially
            //lock submit button
            
        }
        else{
            //user interaction disabled, while data input is then updated
            //patientID.isUserInteractionEnabled = false
            
            //unlock submit button
        }
        check += 1
        
    }
    
   

}
