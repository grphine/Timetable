//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    //MARK: Variables
    var singleEvent = RepeatingEvent()
    var check = 1 //edit disabled
    
    //Sent variables
    var eventName: String!
    var allEvents: [RepeatingEvent]! //FIXME: This is not currently used? Sent from last view
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    @IBOutlet weak var colourPickerButton: UIButton!
    @IBOutlet weak var occurenceButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    //TODO: Add reminder has no connection
    //TODO: Priority should be low medium high picker view
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.delegate = self
        descriptionLabel.delegate = self
        
        //TODO: Change add occurence text depending on whether adding or not
        //Change view triggered depending on whether repeating event or not
        if eventName == "" {
            //unlock interaction for fields when new event is being added
            modifyInteraction(set: true)
            deleteButton.isUserInteractionEnabled = false
            occurenceButton.setTitle("Add Occurences (Day/Time)", for: .normal)
            
        }
        else{
            self.navigationItem.rightBarButtonItem = self.editButtonItem //add edit button to modify data
            
            singleEvent = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: eventName)! //pull data about event
            
            nameLabel.text = singleEvent.name //set data
            descriptionLabel.text = singleEvent.desc
            occurenceButton.setTitle("Edit Occurences (Day/Time)", for: .normal)
            //priorityLabel.text = String(describing: singleEvent.priority)
            //FIXME: output rest of data
            modifyInteraction(set: false) //disable interaction
        }
    }
    
    //MARK: Picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    //MARK: Occurence Button
    @IBAction func occurenceButtonPressed(_ sender: UIButton){
        //get data from collapsable tableview date picker for dates
        //presented as popover
        //Return 2d array, including empties
    }
    
    //MARK: Colour Picker Button
    @IBAction func colourPickerPressed(_ sender: UIButton){
        //pick colours somehow, maybe a popover
    }
    
    
    //MARK: Edit Button
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
         
         use some table to store taken event times, and if time check table for conflicts (ideally inform user which has conflict)
         */
        
        //if all good:
        
        //Make sure event was grabbed by primary key to ensure it is edited rather than remade
        //Unless they are adding a new event, in which case the above is unecessary. Add bool for check
        
        //perform validation on data input (priority is int, occurences isn't nil)
        //present popup depending on issue
        
        //send alerts of data being updated
        
        //MARK: Add data to Realm
        //FIXME: Colour is empty string
        //FIXME: Cannot add event until picker view sorted
        //FIXME: Validate data entry
        
        var newEvent = RepeatingEvent()
        
        if (check == 1){ //edit button has not been pressed, therefore new event added
            newEvent = createEvent(name: nameLabel.text!, colour: "", week: [[]], description: descriptionLabel.text, priority: 3)
        }
        else{
            newEvent = modifyEvent(event: singleEvent, name: nameLabel.text!, colour: "", week: [[]], description: descriptionLabel.text, priority: 3)
        }
        
        try! uiRealm.write { //update within a transaction
            uiRealm.add(newEvent, update: true)
        }
        
        
        let alert = UIAlertController(title: "Info", message: "Schedule Updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Return", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true) //return to Schedule after submitting
        }))
        self.present(alert, animated: true)
    }
    
    //MARK: Delete Button
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "This will permanently delete this event", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in //Delete event if user confirms
            try! uiRealm.write {
                uiRealm.delete(self.singleEvent)
            }
            self.navigationController?.popViewController(animated: true) //return to Schedule after deleting
        }))
        
        self.present(alert, animated: true)
        
    }
    
    //MARK: Add Event and Constituents
    func createEvent(name: String, colour: String, week: [[Int]], description: String, priority: Int) -> RepeatingEvent{
        let event = RepeatingEvent()
        
        event.name = name //add all parameters
        event.colour = colour
        event.desc = description
        event.priority = priority
        
        event.id = name
        //FIXME: Events need to be ID'd in some way. If a user changes the event name, the ID is also changed, giving two events
        
        for day in week{ //for every day in the week, append the day to the week
            event.week.append(timesToDay(times: day))
        }
        
        return event
    }
    
    func modifyEvent(event: RepeatingEvent, name: String, colour: String, week: [[Int]], description: String, priority: Int) -> RepeatingEvent{
        
        event.name = name //modify all parameters
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
    
    //MARK: Modify Interactability
    func modifyInteraction(set: Bool){
        nameLabel.isUserInteractionEnabled = set
        repeatSwitch.isUserInteractionEnabled = set
        priorityPicker.isUserInteractionEnabled = set
        descriptionLabel.isUserInteractionEnabled = set
        colourPickerButton.isUserInteractionEnabled = set
        occurenceButton.isUserInteractionEnabled = set
        submitButton.isUserInteractionEnabled = set
    }
    
    //MARK: Text Setup
    func textViewDidBeginEditing(_ textView: UITextView) { //automatically remove text from text view
        if (textView.text == "Extra Information"){
            textView.text = ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) { //automatically remove text from text field
        if (textField.text == "Event Name"){
            textField.text = ""
        }
    }
    
}
