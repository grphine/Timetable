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
    
    var cell: Int!
    var addNoteSegue: Bool!
    
    let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertController.addAction(dismissAction)
        
        if addNoteSegue == false{ //load data if user tapped on cell
            titleField.text = noteStore[cell][0]
            bodyField.text = noteStore[cell][1]
        }
        else if addNoteSegue == true{
            titleField.text = ""
            bodyField.text = ""
        }
        
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.setBottomBorder() //add border style to title
        
    }
    
  /*
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if addNoteSegue == false{ //load data if user tapped on cell
            titleField.text = noteStore[cell][0]
            bodyField.text = noteStore[cell][1]
        }
        else if addNoteSegue == true{
            titleField.text = ""
            bodyField.text = ""
        }
        
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.setBottomBorder() //add border style to title
        
    }
     */
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem){
        if (titleField.text == "" || bodyField.text == "" || bodyField.text == "Note Description") { //check if empty
            
            alertController.title = "Warning"
            alertController.message = "Please leave no empty fields when saving"
            self.present(alertController, animated: true, completion: nil)
            //if empty, present warning alert
        }
        else{
            noteStore[cell][0] = titleField.text! //else, update data
            noteStore[cell][1] = bodyField.text!
            
//            if addNoteSegue == false{
//                self.navigationController!.popViewController(animated: true) //add note presents modally. Therefore pop from stack
//
//            }
//            else if addNoteSegue == true{
//                self.dismiss(animated: true, completion: nil)
//            }
            self.navigationController!.popViewController(animated: true) //add note presents modally. Therefore pop from stack
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem){
//        if addNoteSegue == false{
//            self.navigationController!.popViewController(animated: true) //add note presents modally. Therefore pop from stack
//
//        }
//        else if addNoteSegue == true{
//            self.dismiss(animated: true, completion: nil)
//        }
        self.navigationController!.popViewController(animated: true) //add note presents modally. Therefore pop from stack
        
    }
    
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
    
    
   /*
 
    onsubmit
        carry out validation the fields aren't empty
        submit the field data to realm
     
     let newNote = NoteData()
     newNote.title = titleField.text!
     newNote.body = bodyField.text!

     
    */

}

extension UITextField{
    func setBottomBorder(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

