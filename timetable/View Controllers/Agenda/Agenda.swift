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
    
    //TODO: deletes
    /*
     find position in array
     find length of queues to find which queue item falls in
     traverse queue to find item at that location
    */
    
    //TODO: segue to schedule?
    //TODO: Event timer countdowns, send notification at time up
    //TODO: Variable priorities
    //TODO: Move addToDictionary to commonly accessible class
    //FIXME: Reloading data after delete not working
    
    /*
     use time since now in view did load
     function to calculate remaining time from (occurence time - time since now)
     pass in remaining time to countdown function, to display to user, update every 15s?
     when view appears, recalculate remaining time and redisplay countdown
     
     when remaining time hits a threshold, bump it up a priority level, and trigger a tableview reload
     
     send user notification if timer hits threshold, or trigger alarm. will probably require realm resturcturing
 
    */
    
    var hours = [9, 17] //pull from settings
    var orderDict = [Int: String]() //IDs of events keyed to the time it occurs
    var orderDictCheck = [Int: String]() //A checking variable used to evaluate whether the original has changed
    var orderArray = [String]() //IDs of events in the order they are to appear
    var timeDifference = 8 //difference between the start and end time
    var startTime = 6 //start time of day
    var allDict = [String: [[Int]]]() //event keyed to occurrences

    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var agendaTableView: UITableView!
    
    var allEvents = [RepeatingEvent]()
    //var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    
    var prioQueueDef = Queue<String>()
    var prioQueueImp = Queue<String>()
    var prioQueueUrg = Queue<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu() //left menu setup
        
        agendaTableView.delegate = self //setup tableview
        agendaTableView.dataSource = self
        
        setupView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupView()
        
        //populate queues and arrays again
        self.agendaTableView.reloadData()
    }
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderArray.count == 0 {
            self.agendaTableView.setEmptyMessage("No Events Today!")
        }else{
            self.agendaTableView.restore()
        }
        
        //number of events in queue, currently only one array
        return (orderArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "agendaCell", for: indexPath) as! AgendaCell
        
        if tableView.numberOfRows(inSection: 0) == 0{ //default case if no events
            cell.titleLabel.text = "No Upcoming Events Today"
        }
        else{
            let event = orderArray[indexPath.row]
            let send = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: event)
            
            cell.configureCell(event: send!)
            
        }
        
        
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
    
    func setupView(){
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short)
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        
        var weekday = Calendar.current.component(.weekday, from: Date())-2 //get today's day as a number (week beginning Sunday [-1]), set Monday as 0 index [-1]
        if weekday == -1 { weekday = 6 } //due to error on Sundays
        
        let allDict = allEvents.addToDictionary()
        
        orderDict = toOrderDict(dict: allDict, weekday: weekday)    //add events into organised dictionary
        
        if orderDict != orderDictCheck{
            
            
            prioQueueDef.dequeueAll() //reset the queues to empty, in case an event was deleted
            prioQueueImp.dequeueAll()
            prioQueueUrg.dequeueAll()
            
            //2d array storing all possible times. checked against for conflicys. if there are, the old item's time is overwritten by reverse searching the realm or keying to its id
            
            queueItems(dict: orderDict, startTime: startTime, timeDifference: timeDifference)   //pushes items in ordered dictionary into relevant queue
            orderArray = prioQueueUrg.outputArray() + prioQueueImp.outputArray() + prioQueueDef.outputArray() //outputs array of items in order they were queued
            orderDictCheck = orderDict
        }
        
    }
    
    func toOrderDict(dict: [String: [[Int]]], weekday: Int) -> [Int: String]{
    
        var dictionary = [Int: String]()
        for event in dict{ //adds events to an organised dictionary for the day  //FIXME: Do for single too
    
            if event.value[weekday] != []{ //if not empty
                for item in event.value[weekday]{
                    dictionary[item] = event.key
                }
            }
        }
        
        return dictionary
    }
    
    func queueItems(dict: [Int: String], startTime: Int, timeDifference: Int){   //pushes items in ordered dictionary into relevant queue
    
        var count = startTime
        
        for _ in 0...timeDifference{
            
            let item = dict[count]
            
            if item != nil{
                let event = uiRealm.object(ofType: RepeatingEvent.self, forPrimaryKey: item)!
    
                switch event.priority{ //queues items based on priority
                case 1:
                    prioQueueImp.enqueue(key: item!)
                case 2:
                    prioQueueUrg.enqueue(key: item!)
                default:
                    prioQueueDef.enqueue(key: item!)
                }
            }
            count += 1
        }
    }
    
}

