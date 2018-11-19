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
    var allNotes = [NoteData]()
    var filteredNotes = [NoteData]()
    let sort = Sorts()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
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
        
        allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData] //add all note items to allNotes array
        filteredNotes = allNotes

        self.tableView.reloadData()
    }
    func reloadData(){
        allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData] //add all note items to allNotes array
        filteredNotes = allNotes
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
        print(notes.count)
        return notes.count
        //displays as many notes as there are in filteredNote
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesCell
        
        let fullnote = filteredNotes[indexPath.row]
        cell.configureCell(note: fullnote)
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("A")
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                print("B")
//                tappedId = (allNotes[indexPath.row] as AnyObject).id
//                print(filteredNotes)
//                print(tappedId)
//                let noteToBeDeleted = uiRealm.object(ofType: NoteData.self, forPrimaryKey: tappedId)! //get note by primary key
//                print(noteToBeDeleted)
//                try! uiRealm.write {
//                    uiRealm.delete(noteToBeDeleted)
//                }
//            }
//            print(filteredNotes)
//            tableView.deleteRows(at: [indexPath], with: .fade) //delete item from table
//        }
        if editingStyle == .delete{
            tappedId = (filteredNotes[indexPath.row]).id
            let noteToDelete = uiRealm.object(ofType: NoteData.self, forPrimaryKey: tappedId)!
            print(noteToDelete)
            try! uiRealm.write {
                uiRealm.delete(noteToDelete)
            }
            allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData]
            filteredNotes = allNotes
            print(filteredNotes)
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
    
    @IBAction func didSelectSort(_ sender: UISegmentedControl) {
        
        var titleArray = [String]()
        var ageArray = [Date]()
        
        
        if sender.selectedSegmentIndex == 0{
            // Date
//            //self.lists = self.lists.sorted("name")
//            print("date")
//            print(filteredNotes[0].age)
            
            for singleNote in filteredNotes{
                ageArray.append(singleNote.age)
                
                ageArray = sort.mergeSort(ageArray)
                
            }
            
            filteredNotes = []
            for date in ageArray{
                //match item to allnote object name and output item in correct position in filtered array
                
                let newItem = uiRealm.objects(NoteData.self).filter("age == '\(date)'")
                filteredNotes.append(newItem.first!)
            }
            
        }
        else{
            // A-Z
            
            for singleNote in filteredNotes{
                titleArray.append(singleNote.title)
                
                titleArray = sort.quickSort(titleArray)
                
            }
            
            filteredNotes = []
            for name in titleArray{
                //match item to allnote object name and output item in correct position in filtered array
                let newItem = uiRealm.objects(NoteData.self).filter("title == '\(name)'")
                filteredNotes.append(newItem.first!)
            }
            
            
            
            
            //let array = Array(uiRealm.objects(NoteData.self).filter("title == '\(titleArray[0])'"))
            
//            var count = 0
//            var abc = [Any]()
//            for _ in filteredNotes{
//                abc.append(uiRealm.objects(NoteData.self).filter("title == '\(titleArray[count])'"))
//                print(abc)
//                count += 1
//            }
            
//            var not = uiRealm.objects(NoteData.self).filter("title = 'AB'")
//            print(not)
            //var newarr = [Any]()
//            for _ in filteredNotes{
//                newarr.append(uiRealm.objects(NoteData.self).filter("name == \(titleArray[0])"))
//            }
//            print(newarr)
//
            
//            //self.lists = self.lists.sorted("createdAt", ascending:false)
//            print("az")
//            print(filteredNotes[1])
//            //print(filteredNotes[1].age as! Double)
            
        }
        
        //self.taskListsTableView.reloadData()
//        var arr = [Double]()
//        var arr2 = [Date]()
//        for item in filteredNotes{
//            //arr.append(item.age as! Double)
//            arr2.append(item.age)
        
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
