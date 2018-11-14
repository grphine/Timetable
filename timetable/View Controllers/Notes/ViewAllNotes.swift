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
    
    var tappedId = String()
    var allNotes = [Any]()
    var filteredNotes = [Any]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Search
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNotes = allNotes.filter { individual in
                return (individual as AnyObject).contains(searchText)
            }
        } else {
            filteredNotes = allNotes
            //since the tableview only displayed what has been searched (filtered), if there are no searches, filtered = all
        }
        tableView.reloadData()
        //reloads tableview with new data given by searching
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        //defines the search bar's actions
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        allNotes = uiRealm.objects(NoteData.self).toArray() //add all note items to allNotes array
        filteredNotes = allNotes
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = filteredNotes as Optional else {
            return 0
        }
        return notes.count
        //displays as many notes as there are in filteredNote

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        let fullnote = allNotes[indexPath.row]
        cell.configureCell(note: fullnote as! NoteData)
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
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                tappedId = (allNotes[indexPath.row] as AnyObject).id
                let noteToBeDeleted = uiRealm.object(ofType: NoteData.self, forPrimaryKey: tappedId)! //get note by primary key
                try! uiRealm.write {
                    uiRealm.delete(noteToBeDeleted)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade) //delete item from table
        }
        allNotes = uiRealm.objects(NoteData.self).toArray()
        tableView.reloadData() //reload after delete
    }
    
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    

    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showNote"{
            if let indexPath = self.tableView.indexPathForSelectedRow { //get indexPath.row here instead of did select row function
                tappedId = (allNotes[indexPath.row] as AnyObject).id
            }
            print(tappedId)
            let destinationVC = segue.destination as! Notes
            destinationVC.addNoteSegue = false
            destinationVC.noteId = tappedId
            
        }
        else if segue.identifier == "addNote"{
        
            let destinationVC = segue.destination as! Notes
            destinationVC.addNoteSegue = true
        }
        
    }
    
}
