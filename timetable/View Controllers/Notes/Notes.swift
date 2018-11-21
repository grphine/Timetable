//
//  Note.swift
//  timetable
//
//  Created by Juheb on 12/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit
import RealmSwift

class Notes: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextView!
    
    var addNoteSegue: Bool! //check whether adding or modifying note
    var noteId: String! //ID has to be string or int
    var currentNote = NoteData() //instantiate note and write the values to database
    
    let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
    
    
    //MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        alertController.addAction(dismissAction)
        
        if addNoteSegue == false{ //load data if user tapped on cell
            currentNote = uiRealm.object(ofType: NoteData.self, forPrimaryKey: noteId)! //get note by primary key
            
            titleField.text = currentNote.title
            bodyField.text = currentNote.body
        }
        
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.setBottomBorder() //add border style to title text field
        
    }
    
    //MARK: Save
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem){
        if (titleField.text == "" || bodyField.text == "" || bodyField.text == "Note Description") { //check if empty
            
            alertController.title = "Warning"
            alertController.message = "Please leave no empty fields when saving"
            self.present(alertController, animated: true, completion: nil)
            //if empty, present warning alert
        }
        else{
            
            let currentDateTime = String(describing: Date(timeIntervalSinceNow: 1)) //convert current date and time into string
            
            if addNoteSegue == true{
                
                try! uiRealm.write { //place all updates within a transaction
                    currentNote.title = titleField.text!
                    currentNote.body = bodyField.text!
                    currentNote.age =  currentDateTime
                    currentNote.id = currentDateTime //write id as primary key for new note, set as time of initial creation
                    
                    uiRealm.add(currentNote)
                }
            }
            else{
                try! uiRealm.write { //place all updates within a transaction
                    currentNote.title = titleField.text!
                    currentNote.body = bodyField.text!
                    currentNote.age = currentDateTime
                    
                    uiRealm.add(currentNote, update: true) //updates object
                }
            }
            
            self.navigationController!.popViewController(animated: true)
        }
        
    }
    
    //MARK: Cancel
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
    }
    

    
    //MARK: Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) { //automatically remove text
        if (textView.text == "Note Description"){
            textView.text = ""
        }
    }

}



