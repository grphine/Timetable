//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController {
    
    //MARK: Variables
    var singleEvent = RepeatingEvent()
    var check = 1 //edit disabled
    
    //Sent variables
    var eventName: String!
    var allEvents: [RepeatingEvent]! //FIXME: This is not currently used? Sent from last view
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var priorityLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    @IBOutlet weak var colourPickerButton: UIButton!
    @IBOutlet weak var occurenceButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    //TODO: Add reminder has no connection
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: change field placeholder text, set priority input as int only
        
        if eventName == "" {
            //unlock interaction for fields when new event is being added
            modifyInteraction(set: true)
            
            
        }
        else{
            self.navigationItem.rightBarButtonItem = self.editButtonItem //add edit button to modify data
            
            singleEvent = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: eventName)! //pull data about event
            
            nameLabel.text = singleEvent.name //set data
            descriptionLabel.text = singleEvent.desc
            priorityLabel.text = String(describing: singleEvent.priority)
            
            modifyInteraction(set: false) //disable interaction
            
            
        }
        
    
    }
    
    @IBAction func occurenceButtonPressed(_ sender: UIButton){
        //get data from collapsable tableview date picker for dates
        //presented as popover
    }
    
    @IBAction func colourPickerPressed(_ sender: UIButton){
        //pick colours somehow, maybe a popover
    }
    
    
    //MARK: Edit button
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        
        if check % 2 == 0 { modifyInteraction(set: true) } //enable interaction on edit button press
        else { modifyInteraction(set: false) } //disable interaction on second press
        
        check += 1 //changes lock state
    }
    
    //MARK: Submit button
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        
        /*case (item conflict){
         store where the conflict was found and output as popup
         case (item out of range)
         output error. Also check inputs dynamically maybe?
         case (repeat event)
         tell user to tap on event in ssv and edit
         */
        
        //if all good:
        
        //Make sure event was grabbed by primary key to ensure it is edited rather than remade
        //Unless they are adding a new event, in which case the above is unecessary. Add bool for check
        
        //perform validation on data input (priority is int, occurences isn't nil)
        //present popup depending on issue
        
        //send alerts of data being updated
        
        //MARK: Add data to Realm
        //FIXME: Colour is empty string
        let newEvent = addEvent(name: nameLabel.text!, colour: "", week: [[]], description: descriptionLabel.text, priority: Int(priorityLabel.text!)!)
        
        try! uiRealm.write { //place all updates within a transaction
            uiRealm.add(newEvent, update: true)
        }
        
        //TODO: Show alert for successful add, pop view
        
        
    }
    
    //MARK: Delete Button
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        //TODO: Throw alert if user presses delete
        //Delete, then pop view
    }
    
    //MARK: Add event
    func addEvent(name: String, colour: String, week: [[Int]], description: String, priority: Int) -> RepeatingEvent{
        let event = RepeatingEvent()
        
        //make a check whether to modify or not. true, edit params by primary key. otherwise add as new
        
        event.name = name //add all parameters
        event.colour = colour
        event.desc = description
        event.priority = priority
        
        for day in week{ //for every day in the week, append the day to the week
            event.week.append(timesToDay(times: day))
        }
        
        return event
    }
    
    func timesToDay(times: [Int]) -> Day{ //create Day objects
        
        let newDay = Day()
        
        for item in times{
            let hour = hoursToTime(hour: item)
            newDay.dayItem.append(hour)
        }
        
        return newDay
    }
    
    func hoursToTime(hour: Int) -> Hour{ //create Hour objects
        let new = Hour()
        new.hourItem = hour
        
        return new
    }
    
    //MARK: Modify interaction
    func modifyInteraction(set: Bool){
        nameLabel.isUserInteractionEnabled = set
        repeatSwitch.isUserInteractionEnabled = set
        dateLabel.isUserInteractionEnabled = set
        priorityLabel.isUserInteractionEnabled = set
        descriptionLabel.isUserInteractionEnabled = set
        colourPickerButton.isUserInteractionEnabled = set
        occurenceButton.isUserInteractionEnabled = set
        submitButton.isUserInteractionEnabled = set
        deleteButton.isUserInteractionEnabled = set
    }
    
    
    
   

}
