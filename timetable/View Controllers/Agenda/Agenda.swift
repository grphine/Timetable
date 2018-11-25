//
//  Agenda.swift
//  timetable
//
//  Created by Juheb on 30/10/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit
import SideMenu

class AgendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //TODO: Add uiRealm.deleteAll() to settings VC
    /*
     get day
     find all events happening on that day
     sort those events (could be repeating) into order of appearance
     as they appear, output to table
     once time has passed, clear from table
     
     allow user to tap on item and view its details
 
 */
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var agendaTableView: UITableView!
    
    var allEvents = [RepeatingEvent]()
    var timer = Timer()
    let queue = LinkedList(data: String())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu() //left menu setup
        
        agendaTableView.delegate = self //setup tableview
        agendaTableView.dataSource = self
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //dateTimeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        
        
        //allNotes = uiRealm.objects(NoteData.self).toArray() as! [NoteData] //add all note items to allNotes array
        //filteredNotes = allNotes
        
        
        self.agendaTableView.reloadData()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of events that haven't passed
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgendaCell()
        
        return cell
    }
    
    
    
    
    //MARK: Menu setup
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

