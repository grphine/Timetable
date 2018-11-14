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
    var noteId: String! //ID is string
    var currentNote = NoteData() //instantiate note and write the values to database
    
    let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertController.addAction(dismissAction)
        
        if addNoteSegue == false{ //load data if user tapped on cell
            currentNote = realm.object(ofType: NoteData.self, forPrimaryKey: noteId)! //get note by primary key
            
            titleField.text = currentNote.title
            bodyField.text = currentNote.body
        }
        
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.setBottomBorder() //add border style to title
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem){
        if (titleField.text == "" || bodyField.text == "" || bodyField.text == "Note Description") { //check if empty
            
            alertController.title = "Warning"
            alertController.message = "Please leave no empty fields when saving"
            self.present(alertController, animated: true, completion: nil)
            //if empty, present warning alert
        }
        else{
            
            if addNoteSegue == true{
                noteId = String(describing: Date(timeIntervalSince1970: 1)) //create new ID
            }
            
            currentNote.title = titleField.text!
            currentNote.body = bodyField.text!
            currentNote.age = Date(timeIntervalSinceNow: 1)
            currentNote.id = noteId
            
            try! realm.write { () -> Void in
                realm.add(currentNote, update: true)
            }
            
            self.navigationController!.popViewController(animated: true)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem){
        self.navigationController!.popViewController(animated: true)
    }
    
    //add delete note button?
//    // let cheeseBook = ... Book stored in Realm
//
//    // Delete an object with a transaction
//    try! realm.write {
//    realm.delete(cheeseBook)
//    }
    
    //Text Field
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

extension UITextField{
    func setBottomBorder(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

