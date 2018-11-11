//
//  Event.swift
//  
//
//  Created by Juheb on 11/11/2018.
//

import UIKit

class EventVC: UIViewController {
    
    var eventItem = EventItem()
    var name = String()
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var priorityLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    var columnRow: [Int]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = eventItem.nameFinder(column: columnRow[0], row: columnRow[1])
        
        if name == ""{
            //error
        }
        else{
            nameLabel.text = name
            descriptionLabel.text = eventItem.descFinder(column: columnRow[0], row: columnRow[1])
        }
        
        //print(columnRow as [Int])

        
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
