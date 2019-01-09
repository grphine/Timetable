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
    
    /*
     get current date
     calculate date of monday from current date
     find any single events with that monday date as their week id
     
     */
    
    
    /*
     get day
     find all events happening on that day
     sort those events (could be repeating) into order of appearance
     as they appear, output to table
     once time has passed, clear from table
     
     allow user to tap on item and view its details
 
 */
    
    //TODO: segue to a new view when selecting cell, no modifications possible
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var agendaTableView: UITableView!
    
    var allEvents = [RepeatingEvent]()
    //var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    let queue = Queue<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu() //left menu setup
        
        agendaTableView.delegate = self //setup tableview
        agendaTableView.dataSource = self
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short)
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //dateTimeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        
        self.agendaTableView.reloadData()
    }
    
    //MARK: TableView
    
    /*
     1 section
     queue length rows
     
     populate tableview as items in queue
     
     once item's time of occurence has passed, dequeue
     
     have three queues for three priorities
     have some logic to allow moving between priorities, if time moves below certain threshhold. allow change of local priority of queue item
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of events in queue
        return queue.length()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgendaCell()
        
        
        //get items in queue sequentially 
        //set name of cell
        //calculate occurence time
        //colours done internally
        
        return cell
    }
    
    //not working
//    //MARK: Timer
//    @objc func update(){
//        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short)
//        print(dateLabel.text)
//    }
    
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

