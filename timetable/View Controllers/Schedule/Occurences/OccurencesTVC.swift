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
    //TODO: Return data to VC on submit
    //TODO: Display already selected cells on edit
    
    let hours = [9, 10, 11, 12]
    let days = ["MONDAY", "TUESDAY", "WEDNESDAY"]
    var occurences: [[Int]] = [[], [], [], [], [], [], []]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        //TODO: change back text and add submit button (no necessarily in nav bar)
        //self.navigationItem.backBarButtonItem?.title = "Cancel"

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
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton){
        
        
        
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
            var day = 0
            for item in selected!{ //loops array and adds hours to their days in occurences array
                if item[0] == day{
                    occurences[day].append(item[1])
                }else{
                    occurences[day + 1].append(item[1])
                    day += 1
                }
            }
            
            let alert = UIAlertController(title: "Info", message: "Save selected times?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.submitAndReturn() //return and send empty data to EventVC
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    //MARK: Navigation
    func submitAndReturn() { //sends data and returns to previous view
        let stack = self.navigationController?.viewControllers
        let previousView = stack![stack!.count - 2] as! EventVC
        previousView.occurences = occurences
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
