//
//  OccurencesTVC.swift
//  timetable
//
//  Created by Juheb on 23/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class OccurencesTVC: UITableViewController, UINavigationControllerDelegate {
    
    var hours = [String]()
    let days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    var occurences: [[Int]]?
    var startTime = Int()
    var settings = SettingsStore()
    var eventName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        settings = uiRealm.object(ofType: SettingsStore.self, forPrimaryKey: "1")!
        startTime = settings.lowerBound
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        navigationItem.rightBarButtonItem = submitButton
        
        setupSelection() //display selected cells when view loads
        
        setupTimes()
        
    }
        

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(describing: days[section])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timesCell", for: indexPath) as! OccurencesCell

        let itemInTable = globalTable[indexPath.section]![indexPath.row+settings.lowerBound]
        
        if itemInTable == ""{ //empty position, generate all first
            cell.nameLabel.text = String(describing: hours[indexPath.row])
            cell.nameLabel.textColor = UIColor.black
            cell.isUserInteractionEnabled = true
        }
        else{ //position is filled
            if eventName == itemInTable{ //action to carry out in the case the item matching the event passed
                cell.nameLabel.text = String(describing: hours[indexPath.row])
                cell.nameLabel.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
            }
            else{ //cell taken up by another event
                cell.nameLabel.text = itemInTable
                cell.nameLabel.textColor = UIColor(hex: uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: itemInTable)!.colour)
                cell.tintColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
            }
        }

        return cell
    }
    
    
    @objc func submitButtonPressed(){
        
        let selected = self.tableView.indexPathsForSelectedRows
        
        if selected == nil{
            let alert = UIAlertController(title: "Warning", message: "No times were added \n Are you sure you want to return?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true) //return and send empty data to EventVC
            }))
            self.present(alert, animated: true)
            
            //if no dates selected, then submitting event in previous screen deletes it
            
        }
        else{
            
            let alert = UIAlertController(title: "Info", message: "Save selected times?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
             
                self.occurences = [[], [], [], [], [], [], []]
                for item in selected!{ //loops array and adds hours to their days in occurences array
                    
                    self.occurences![item[0]].append(item[1]) //append time indexPath + time difference
                    
                }
                self.submitAndReturn() //return and send empty data to EventVC
                
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    //MARK: Setup View
    func setupSelection(){
        var count = 0
        for day in occurences!{
            for hour in day{
                let path = NSIndexPath(row: hour, section: count) 
                tableView.selectRow(at: path as IndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
            count += 1
        }
    }
    
    func setupTimes(){
        hours = []
        if settings.twentyFour == true{
            //generate 24 hour times
            for x in settings.lowerBound...settings.upperBound{
                var string = ""
                if x < 12{
                    string = "0\(x):00"
                }
                else{
                    string = "\(x):00"
                }
                hours.append(string)
            }
        }
        else{
            //generate 12 hour times
            for x in settings.lowerBound...settings.upperBound{
                var string = ""
                if x < 12{
                    if x == 0{
                        string = "12:00am"
                    }
                    else{
                        string = "\(x):00am"
                    }
                }
                else{
                    if x != 12{
                        string = "\(x-12):00pm"
                    }
                    else{ string = "12:00pm"}
                }
                hours.append(string)
            }
        }
    }
    
    //MARK: Navigation
    func submitAndReturn() { //sends data and returns to previous view
        let stack = self.navigationController?.viewControllers
        let previousView = stack![stack!.count - 2] as! EventVC
        previousView.occurences = occurences
        self.navigationController?.popViewController(animated: true)
    }
    
}
