//
//  Agenda.swift
//  timetable
//
//  Created by Juheb on 30/10/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit
import SideMenu

class AgendaViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu() //left menu setup
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        
        
        
    }
    
    fileprivate func setupSideMenu() {
        
        typealias m = SideMenuManager //typealias SideMenuManager to ease typing
        
        // Define the menus
        m.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        //SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController

        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        m.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        m.default.menuAddScreenEdgePanGesturesToPresent(toView:forMenu:) //gestures for one menu
        
        m.default.menuFadeStatusBar = false //fix black menu
        
        m.default.menuPushStyle = .popWhenPossible //If a view controller already in the stack is of the same class as the pushed view controller, the stack is instead popped back to the existing view controller. This behavior can help users from getting lost in a deep navigation stack.
        
        m.default.menuPresentMode = .viewSlideInOut //The existing view slides out while the menu slides in.
        
        
        
    }
    
    


}

