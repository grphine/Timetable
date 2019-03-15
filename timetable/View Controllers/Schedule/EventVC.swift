//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Variables
    var repeatingEvent = RepeatingEvent()
    var hashTable = HashTable()
    var settings = SettingsStore()
    var check = 1 //edit disabled
    let priorities = ["Normal", "Important", "Urgent"]
    
    //Sent variables
    var eventName: String!
    var repeating: Bool!
    
    //Recieved variable
    var occurences: [[Int]]?
    var colour: String?
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var priorityPicker: UIPickerView!
    
    @IBOutlet weak var colourPickerButton: UIButton!
    @IBOutlet weak var occurenceButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatSwitch.isHidden = true
        switchLabel.isHidden = true
        
        
        repeating = true
        
        nameLabel.delegate = self
        descriptionLabel.delegate = self
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        occurences = [[], [], [], [], [], [], []] //setup occurences
        
        if eventName == "" { //setup in all cases when a new event is being added
            //unlock interaction for fields when new event is being added
            modifyInteraction(set: true)
            submitButton.isUserInteractionEnabled = true
            deleteButton.isHidden = true
            occurenceButton.setTitle("Add Occurences (Day/Time)", for: .normal)
            submitButton.setTitle("Create Event", for: .normal)
        }
        else{
            repeatSwitch.isHidden = true //hide switch since user cannot modify after initial seleection
            switchLabel.isHidden = true
            
            self.navigationItem.rightBarButtonItem = self.editButtonItem //add edit button to modify data
            
            repeatingEvent = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: eventName)! //pull data about event
            
            nameLabel.text = repeatingEvent.name //set data
            descriptionLabel.text = repeatingEvent.desc
            colour = repeatingEvent.colour
            occurenceButton.setTitle("Edit Occurences (Day/Time)", for: .normal)
            priorityPicker.selectRow(repeatingEvent.priority, inComponent: 0, animated: true)
            submitButton.setTitle("Update Event", for: .normal)
            occurences = weekToOccurences(event: repeatingEvent)
            
            modifyInteraction(set: false) //disable interaction
        
        }
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
    
    
    
    //MARK: Edit Button
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        
        check += 1 //changes lock state
        
        if check % 2 == 0 { //enable interaction on edit button press
            modifyInteraction(set: true)
            submitButton.isUserInteractionEnabled = true
            nameLabel.isUserInteractionEnabled = false
        } else { modifyInteraction(set: false) } //disable interaction on second press
        
    }
    
    //MARK: Submit button
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let defaultAlert = UIAlertController(title: "Info", message: "", preferredStyle: .alert) //create a default alert to modify as necessary
        defaultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        var valid = false //check whether all input is valid
        
        if (occurences == [[], [], [], [], [], [], []]) || (nameLabel.text == "" || nameLabel.text == "Event Name") || (colour == nil){
            valid = false
        } else {valid = true}
        
        //MARK: Update schedule
        if valid == true{ //only submit if all data is valid
            let successAlert = UIAlertController(title: "Info", message: "Schedule Updated", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "Return", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true) //return to Schedule after submitting
            }))
            
            try! uiRealm.write { //update within a transaction
                //MARK: Create/modify event object
                var newEvent = RepeatingEvent()
                if (check == 1){ //edit button has not been pressed, therefore new event added
                    newEvent = createEvent(name: nameLabel.text!, colour: colour!, week: occurences!, description: descriptionLabel.text, priority: priorityPicker.selectedRow(inComponent: 0))
                }
                else{
                    newEvent = modifyEvent(event: repeatingEvent, name: nameLabel.text!, colour: colour!, week: occurences!, description: descriptionLabel.text, priority: priorityPicker.selectedRow(inComponent: 0))
                }
                uiRealm.add(newEvent, update: true)
            }
            
            self.hashTable.populateTable(timeDifference: self.settings.lowerBound)
            self.present(successAlert, animated: true)
        }
        else{
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
                uiRealm.delete(self.repeatingEvent)
            }
            self.hashTable.populateTable(timeDifference: self.settings.lowerBound)
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
    
    //MARK: Get occurences from RepeatingEvent week array
    func weekToOccurences(event: RepeatingEvent) -> [[Int]]{
        let week = event.week
        
        var weekOccurences = [[Int]]()
        for day in week{
            var hourOccurences = [Int]()
            for hour in day.dayItem{
                hourOccurences.append(hour.hourItem)
            }
            weekOccurences.append(hourOccurences)
        }
        
        return weekOccurences
    }
    
    
    //MARK: Modify Interactability
    func modifyInteraction(set: Bool){
        repeatSwitch.isUserInteractionEnabled = set
        priorityPicker.isUserInteractionEnabled = set
        descriptionLabel.isUserInteractionEnabled = set
        colourPickerButton.isUserInteractionEnabled = set
        occurenceButton.isUserInteractionEnabled = set
        
        if set == false{
            priorityPicker.alpha = 0.5
            priorityLabel.alpha = 0.5
            colourPickerButton.alpha = 0.5
            occurenceButton.alpha = 0.5
            //submitButton.alpha = 0.5
        }
        else{
            priorityPicker.alpha = 1
            priorityLabel.alpha = 1
            colourPickerButton.alpha = 1
            occurenceButton.alpha = 1
            //submitButton.alpha = 1
        }
        
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
            let destinationVC = segue.destination as! OccurencesTVC
            destinationVC.occurences = occurences
            destinationVC.eventName = eventName
        }
        else if segue.identifier == "colourPickerSegue"{
            let destinationVC = segue.destination as! ColourPickerViewController
            destinationVC.colour = colour
        }
        
    }
    
}
