//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController {
    
    var event = Event()
    var name = String()
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var priorityLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    var columnRow: [Int]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = event.nameByCell(column: columnRow[0], row: columnRow[1])
        
        if name == ""{
            //error
        }
        else{
            nameLabel.text = name
            descriptionLabel.text = event.descByCell(column: columnRow[0], row: columnRow[1])
        }
        
        //print(columnRow as [Int])
        
        //let maths = EventItem(name: "Maths", colour: UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1), occurences: [[11,12],[11],[13],[],[],[14],[14]], description: "maths lesson")

        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        /*case (item conflict){
            store where the conflict was found and output as popup
         case (item out of range)
            output error. Also check inputs dynamically maybe?
         case (repeat event)
            tell user to tap on event in ssv and edit
 
        */
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
