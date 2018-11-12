//
//  Alert.swift
//  timetable
//
//  Created by Juheb on 12/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import UIKit

class alertClass: UIAlertController {
    
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    var count: Int = 0
    
    
    func defaultAlert(alertTitle: String, alertMessage:String) -> UIAlertController {
        alertController.title = alertTitle
        alertController.message = alertMessage
        //Sets the alert title and message as the parameters passed into the function
        
        if count < 1 {
            alertController.addAction(defaultAction)
            count += 1
            //Ensures the dismiss button is only added to the alert once, and not every time this function is called
        }
        return alertController
    }
    
}

/* Usage
 
 present(alert.defaultAlert(alertTitle: "Info", alertMessage: "Submission has been saved"), animated: true, completion: nil)
 
 let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete this patient? \n This action is irreversible", preferredStyle: UIAlertControllerStyle.alert)
 //warn user what happens if they press yes
 alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
 UIAlertAction in
 
 //carry out function
 
 })
 
 alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
 
 self.present(alertController, animated: true, completion: nil)
 
 */
