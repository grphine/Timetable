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
    
    var tappedId = String()
    var allNotes = [NoteData]()
    var filteredNotes = [NoteData]()
    let sort = Sorts()
    let searchController = UISearchController(searchResultsController: nil)
    let formatter = DateFormatter()
    
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
        
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //let someDateTime = formatter.date(from: "2018-11-20 20:03:34")
//        print(someDateTime)
//
//        //let theAge: Date = (2018-11-20 20:03:34 +0000)
//        let abc = uiRealm.objects(NoteData.self).filter("age = '\(someDateTime!)'")
//        print(abc)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData] //add all note items to allNotes array
        filteredNotes = allNotes
        print(allNotes)

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
        //displays as many notes as there are in filteredNotes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        let fullnote = filteredNotes[indexPath.row]
        cell.configureCell(note: fullnote) //function configures each cell
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let noteToDelete = (filteredNotes[indexPath.row]) //get note object from filtered array
            try! uiRealm.write {
                uiRealm.delete(noteToDelete)
            }
            allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData] //reset data after deleting note
            filteredNotes = allNotes
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
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
    
    //MARK: Search
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNotes = allNotes.filter { notes in
                return (notes.body.contains(searchText.lowercased()) || notes.title.contains(searchText.lowercased()))
            }
        } else {
            filteredNotes = allNotes
            //since the tableview only displayed what has been searched (filtered), if there are no searches, filtered = all
        }
        tableView.reloadData()
        //reloads tableview with new data given by searching
    }
    
    //MARK: Sort
    @IBAction func didSelectSort(_ sender: UISegmentedControl) {
        
        var titleArray = [String]()
        var ageArray = [Date]()
        
        
        if sender.selectedSegmentIndex == 0{
            // Date
//            //self.lists = self.lists.sorted("name")
//            print("date")
//            print(filteredNotes[0].age)
            
            for singleNote in filteredNotes{
                print(singleNote.age)
                
                let age = formatter.date(from: singleNote.age)
                print(age)
                
                ageArray.append(age) //convert ages into date types
                
            }
            print(ageArray)
            ageArray = sort.mergeSort(ageArray)
            print(ageArray)
            
            filteredNotes = []
            for date in ageArray{
                
                //match item to allnote object name and output item in correct position in filtered array
                
                let newItem = uiRealm.objects(NoteData.self).filter("age = '\(date)'")
                print(newItem)
                filteredNotes.append(newItem.first!)
            }
            
        }
        else{
            // A-Z
            for singleNote in filteredNotes{
                titleArray.append(singleNote.title)
            }
            titleArray = sort.quickSort(titleArray)
            
            filteredNotes = []
            for name in titleArray{
                //match item to allnote object name and output item in correct position in filtered array
                let newItem = uiRealm.objects(NoteData.self).filter("title == '\(name)'")
                filteredNotes.append(newItem.first!)
            }
        }
        tableView.reloadData() //reload after sort
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
