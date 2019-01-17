//
//  OccurencesTVC.swift
//  timetable
//
//  Created by Juheb on 23/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class OccurencesTVC: UITableViewController, UINavigationControllerDelegate {
    
    //TODO: Get these collapsing
    //FIXME: times here too
    let hours = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM",
                 "3:00 PM", "4:00 PM", "5:00PM"]
    let days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    var occurences: [[Int]]?
    let startTime = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        navigationItem.rightBarButtonItem = submitButton
        
        setupSelection() //display selected cells when view loads
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

        cell.nameLabel.text = String(describing: hours[indexPath.row])
        
        //if time is an occurence, present view with it selected
        

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
                    
                    self.occurences![item[0]].append(item[1] + self.startTime) //append time indexPath + time difference
                    
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
                let path = NSIndexPath(row: (hour - startTime), section: count) 
                tableView.selectRow(at: path as IndexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
            count += 1
        }
    }
    
    //MARK: Navigation
    func submitAndReturn() { //sends data and returns to previous view
        let stack = self.navigationController?.viewControllers
        let previousView = stack![stack!.count - 2] as! EventVC
        previousView.occurences = occurences
        print(occurences)
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
