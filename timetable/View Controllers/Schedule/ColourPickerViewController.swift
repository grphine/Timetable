//
//  ColourPickerViewController.swift
//  timetable
//
//  Created by Juheb on 03/12/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class ColourPickerViewController: UIViewController {
    
    @IBOutlet var colorWell:ColorWell!
    @IBOutlet var colorPicker:ColorPicker!
    @IBOutlet var huePicker:HuePicker!
    var pickerController:ColorPickerController?
    @IBOutlet var label:UILabel!
    var colour: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The ColorPickerController handels lets you connect a colorWell, a colorPicker and a huepicker. The ColorPickerController takes care of propagating changes between the individual components.
        pickerController = ColorPickerController(svPickerView: colorPicker, huePickerView: huePicker, colorWell: colorWell)
        //Instead of setting an initial color on all 3 ColorPicker components, the ColorPickerController lets you set a color which will be propagated to the individual components.
        if colour == nil{
            pickerController?.color = UIColor.red
        }
        else {
            pickerController?.color = UIColor(hex: colour!)
        }
        
        /* you shoudln't interact directly with the individual components unless you want to do customization of the colorPicker itself. You can provide a closure to the pickerController, which is going to be invoked when the user is changing a color. Notice that you will receive intermediate color changes. You can use these by coloring the object the User is actually trying to color, so she/he gets a direct visual feedback on how a color changes the appearance of an object of interet. The ColorWell aids in this process by showing old and new color side-by-side.
         */
        pickerController?.onColorChange = {(color, finished) in
            
            self.colour = color.toHexString
            self.label.text = self.colour
            self.label.backgroundColor = color.withAlphaComponent(0.2)
            self.label.textColor = color
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Submit button function to return colour, change button tint and text colour

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        //FIXME: Convert color to colour string, send to vc
        let stack = self.navigationController?.viewControllers
        let previousView = stack![stack!.count - 2] as! EventVC
        previousView.colour = colour
        self.navigationController?.popViewController(animated: true)
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
