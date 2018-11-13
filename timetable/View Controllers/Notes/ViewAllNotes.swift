//
//  NotesTVC.swift
//  timetable
//
//  Created by Juheb on 12/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit
import RealmSwift

class ViewAllNotes: UITableViewController, UISearchResultsUpdating {
    
    //pull the notes from realm
    //get array of notes
    
    var cell = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        //defines the search bar's actions
        
        noteStore.append(["3", "aigbaigbafg"])
        noteStore.append(["4", "asdufbadsfybasdofuybasdfasdfsdfasdfafvzdfbvbdvasdasdszvzdfv"])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //sortedIDs = allData.keys.sorted()
        //filteredPatients = sortedIDs.sorted()
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteStore.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        let fullnote = noteStore[indexPath.row]
        // Configure the cell...
        cell.configureCell(note: fullnote)
        //cannot configure cell
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade) //delete item from table
            noteStore.remove(at: indexPath.row) //and from data
        }
        
        tableView.reloadData() //reload after delete
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 

    //MARK: Navigation
    func tableView(_ tableView: UITableView, didSelectItemAt indexPath: IndexPath) {
        
        cell = indexPath.row
        performSegue(withIdentifier: "showNote", sender: nil)
        print(cell)
    }
    @IBAction func addNoteButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addNote", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showNote"{
            
            let destinationVC = segue.destination as! Notes
            destinationVC.cell = cell
            destinationVC.addNoteSegue = false
            
        }
        else if segue.identifier == "addNote"{
        
            let destinationVC = segue.destination as! Notes
            destinationVC.addNoteSegue = true
            
        }
        
    }
    
    
    

}
