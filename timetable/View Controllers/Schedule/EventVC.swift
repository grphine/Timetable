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
    let priorities = ["Normal", "Important", "Urgent"]
    
    //Sent variables
    var eventName: String!
    //var allEvents: [RepeatingEvent]! //FIXME: This is not currently used? Sent from last view
    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    @IBOutlet weak var colourPickerButton: UIButton!
    @IBOutlet weak var occurenceButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    //TODO: Add reminder has no connection

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.delegate = self
        descriptionLabel.delegate = self
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        if eventName == "" { //setup in all cases when a new event is being added
            //unlock interaction for fields when new event is being added
            modifyInteraction(set: true)
            deleteButton.isHidden = true
            occurenceButton.setTitle("Add Occurences (Day/Time)", for: .normal)
        }
        else{
            if repeatSwitch.isOn == true{ //TODO: Better check for repeating or not
                repeatSwitch.isHidden = true //hide switch since user cannot modify after initial seleection
                switchLabel.isHidden = true
                
                self.navigationItem.rightBarButtonItem = self.editButtonItem //add edit button to modify data
                
                singleEvent = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: eventName)! //pull data about event
                
                nameLabel.text = singleEvent.name //set data
                descriptionLabel.text = singleEvent.desc
                occurenceButton.setTitle("Edit Occurences (Day/Time)", for: .normal)
                priorityPicker.selectRow(singleEvent.priority, inComponent: 0, animated: true)
                //FIXME: output rest of data
                modifyInteraction(set: false) //disable interaction
            }
            else{
                //TODO: Get data from single events
            }
        }
        //TODO: Change view triggered depending on whether repeating event or not
        
        
        //dummy data
//        let newEvent = createEvent(name: "Maths", colour: "42B6F4", week: [[10,11,12,13],[12,13],[13,15],[],[],[],[]], description: "Maths Repeating Event", priority: 0)
//
//        try! uiRealm.write { //update within a transaction
//            uiRealm.add(newEvent, update: true)
//        }
    }
    
    //MARK: Picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
    //MARK: Occurence Button
    @IBAction func occurenceButtonPressed(_ sender: UIButton){
        //TODO: Occurence button
        //get data from collapsable tableview date picker for dates
        //presented as popover
        //Return 2d array, including empties
        
        if check != 1{
            //send singleEvent, otherwise send nothing
        }
        
    }
    
    //MARK: Colour Picker Button
    @IBAction func colourPickerPressed(_ sender: UIButton){
        //pick colours somehow, maybe a popover
    }
    
    
    //MARK: Edit Button
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        
        check += 1 //changes lock state
        
        if check % 2 == 0 { modifyInteraction(set: true) } //enable interaction on edit button press
        else { modifyInteraction(set: false) } //disable interaction on second press
        
        
    }
    
    //MARK: Submit button
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let defaultAlert = UIAlertController(title: "Info", message: "", preferredStyle: .alert) //create a default alert to modify as necessary
        defaultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        var valid = false //check whether all input is valid
        /*
         checks made:
         whether repeating event, and if dates selected correspond
         fields have non-empty, non-default text
        */
        
        /*case (item conflict){
         store where the conflict was found and output as popup
         case (item out of range)
         output error. Also check inputs dynamically maybe?
         case (repeat event)
         tell user to tap on event in ssv and edit
         
         //TODO: Occurences table
         use some table to store taken event times, and if time check table for conflicts (ideally inform user which has conflict)
         //create occurences 2d array. [day][hour] = event name
         //perform check whether [day][hour] == ""
         //if so, throw error
         //when deleting event, reset all its events to default
         */
        
        //if all good:
        
        //perform validation on data input (priority is int, occurences isn't nil)
        //present popup depending on issue
        
        //send alerts of data being updated
        
        //MARK: Add data to Realm
        //FIXME: Colour is empty string
        //FIXME: Cannot add event until picker view sorted
        //FIXME: Validate data entry
        
        //MARK: Create/modify event object
        //TODO: Needs to be protected in transaction apparently
        var newEvent = RepeatingEvent()
        if (check == 1){ //edit button has not been pressed, therefore new event added
            newEvent = createEvent(name: nameLabel.text!, colour: "", week: [[]], description: descriptionLabel.text, priority: priorityPicker.selectedRow(inComponent: 0))
        }
        else{
            newEvent = modifyEvent(event: singleEvent, name: nameLabel.text!, colour: "", week: [[]], description: descriptionLabel.text, priority: priorityPicker.selectedRow(inComponent: 0))
        }
        
        //MARK: Update schedule
        if valid == true{ //only submit if all data is valid
            let successAlert = UIAlertController(title: "Info", message: "Schedule Updated", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "Return", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true) //return to Schedule after submitting
            }))
            
            try! uiRealm.write { //update within a transaction
                uiRealm.add(newEvent, update: true)
            }
            self.present(successAlert, animated: true)
        }
        else{
            //TODO: Present different alert depending on what the invalid is
            defaultAlert.title = "Info"
            defaultAlert.message = "Some fields may have invalid data \n Please try again"
            
            self.present(defaultAlert, animated: true)
        }
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
        
        event.week.removeAll() //clear week before appending new data
        
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
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: Fix segue
        if segue.identifier == "occurenceSegue"{
            //send over occurence data
        }
        
    }
    
}
