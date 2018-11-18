//
//  ViewController.swift
//  SpreadsheetView
//
//

import UIKit
import SpreadsheetView

class ScheduleView: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    var currentEvent = RepeatingEvent()
    var allEvents = [RepeatingEvent]()
    var row = 0
    var column = 0 //to send row and column data to event view
    var allDict = [String: [[Int]]]() //hold each event, its days, and occurences per day
    

    let dates = ["01/11/18", "02/11/2018", "03/11/2018", "04/11/2018", "05/11/2018", "06/11/2018", "08/11/2018"]
    let days = ["MONDAY", "TUESDAY", "WEDNSDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    let hours = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM",
                 "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        
        
        
        let ce = addEvent(name: "Maths", colour: UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1).toHexString, week: [[9, 12, 13],[9],[13],[13],[14,15,16],[],[]], description: "Maths lesson", priority: 3, modify: false)
        
//        let mon = timesToDay(times: [11,12,13])
//        let tue = timesToDay(times: [11,12])
//        let wed = timesToDay(times: [14,15])
//        let thu = timesToDay(times: [16,17])
//        let fri = timesToDay(times: [9,10])
//        let sat = timesToDay(times: [9])
//        let sun = timesToDay(times: [9])
//        //mon.day.append(time = 11)
//
//        let ce = RepeatingEvent(value: ["name": "English",
//                                        "colour": UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1).toHexString,
//                                        "week": [mon,tue,wed,thu,fri,sat,sun],
//                                        "desc": "english lesson",
//                                        "priority": 3])
//
        //
//            let empty = Time()
//            empty.time = 0
//            let hour1 = Time()
//            hour1.time = 11
//            let hour2 = Time()
//            hour2.time = 12
//            let hour3 = Time()
//            hour3.time = 14
//            //write data for a week
//            let monday = Day()
//            monday.times.append(hour1)
//            monday.times.append(hour2)
//            let tuesday = Day()
//            tuesday.times.append(hour3)
//            let wednesday = Day()
//            wednesday.times.append(hour1)
//            wednesday.times.append(hour3)
//            let thur = Day()
//            thur.times.append(empty)
//            let fri = Day()
//            fri.times.append(empty)
//            let sat = Day()
//            sat.times.append(empty)
//            let sun = Day()
//            sun.times.append(empty)
//
//            //write all event data
//            currentEvent.name = "Maths"
//            currentEvent.colour = UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1).toHexString
//            currentEvent.desc = "maths lesson"
//            currentEvent.priority = 3
//            currentEvent.week.append(monday)
//            currentEvent.week.append(tuesday)
//            currentEvent.week.append(wednesday)
//            currentEvent.week.append(thur)
//            currentEvent.week.append(fri)
//            currentEvent.week.append(sat)
//            currentEvent.week.append(sun)
            
//        try! uiRealm.write { //place all updates within a transaction
//
//            uiRealm.add(ce, update: true)
//        }
        
        //Load data into array
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        //print(allEvents)
        
//        for event in allEvents{
//            for day in event.week{
//                for hour in day.dayItem{
//                print("Event: \(event.name) day:\(day)")
//                }
//
//            }
//        }
//
        
        allDict = addToDictionary(all: allEvents)
        print(allDict)
        
        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        //MARK: Dummy Data
//        let english = EventItem(name: "English", colour: UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1), occurences: [[9,10,11],[12],[11],[],[],[],[]], description: "english lesson", priority: 3)
//        let maths = EventItem(name: "Maths", colour: UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1), occurences: [[11,12],[11],[13],[],[],[14],[14]], description: "maths lesson", priority: 3)
//        
//        RepeatingEvents.append(english)
//        RepeatingEvents.append(maths)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    // MARK: DataSource
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2 + hours.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 70
        } else {
            return 120
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else if case 1 = row {
            return 32
        } else {
            return 40
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        
        //c1-end,r0 - set the date of the columns
        if case (1...(dates.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.text = dates[indexPath.column - 1]
            return cell
            
        //c1-end,r1 - set day names of columns
        } else if case (1...(days.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column - 1]
            return cell
            
        //c0,r1 - set cell name to TIME
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = "TIME"
            return cell
            
        //c0,r2-end - set hours of columns
        } else if case (0, 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = hours[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
            
        //c1-end,r2-end (i.e. rest of the table) - set all other cells
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            //let text = nameByCell(all: allEvents, column: indexPath.column, row: indexPath.row)
            
            //print(text)

//            let text = nameByCell(all: allEvents, column: indexPath.column, row: indexPath.row)
//            //get event name by its index path and row
//
//            if text != "" {
//                cell.label.text = text
//                let colour = colourByCell(array: allEvents, column: indexPath.column, row: indexPath.row)
//                //get event colour
//                cell.label.textColor = colour
//                cell.color = colour.withAlphaComponent(0.2)
//                cell.borders.top = .solid(width: 1, color: colour)
//                cell.borders.bottom = .solid(width: 1, color: colour)
//            } else {
//                cell.label.text = nil
//                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
//                cell.borders.top = .none
//                cell.borders.bottom = .none
//            }


            return cell
        }
        return nil
    }
    
    /// Delegate
    
    //MARK: Segueing to EventVC
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        
        row = indexPath.row
        column = indexPath.column
        
        //get event by above
        if (column >= 1 && row >= 2){
            performSegue(withIdentifier: "eventCreationSegue", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventCreationSegue"{
        
            let destinationVC = segue.destination as! EventVC
            destinationVC.columnRow = [column, row] //send column and row to event creation view
        }
        
    }
    
    //-----------------------------------------
    
    func addEvent(name: String, colour: String, week: [[Int]], description: String, priority: Int, modify: Bool) -> RepeatingEvent{
        let event = RepeatingEvent()
        
        //make a check whether to modify or not. true, edit params by primary key. otherwise wipe and add as new
        
        event.name = name //add all parameters
        event.colour = colour
        event.desc = description
        event.priority = priority
        
        for day in week{ //for every day in the week, append the day to the week
            event.week.append(timesToDay(times: day))
        }
        
        return event
    }
    
    
    func timesToDay(times: [Int]) -> Day{
        
        let newDay = Day()
        
        for item in times{
            let hour = hoursToTime(hour: item)
            newDay.dayItem.append(hour)
        }
    
        return newDay
    }
    
    func hoursToTime(hour: Int) -> Hour{
        let new = Hour()
        new.hourItem = hour
        
        return new
    }

    
    //MARK: Getting event data

    func addToDictionary(all: [RepeatingEvent]) -> [String: [[Int]]]{

        var eventTimes = [String: [[Int]]]()
        var dayHours = [[Int]]()
        var hours = [Int]()

        for event in all{
            for day in event.week{
                for hour in day.dayItem{
                    hours.append(hour.hourItem)
                }

                dayHours.append(hours)
            }
            eventTimes[event.name] = dayHours
        }

        return eventTimes
    }
    
//    func nameByCell(all: [RepeatingEvent], column: Int, row: Int) -> String{ //get event name by cell
//
//        var subject = ""
//        let string = "week[\(column-1)][\(row+4)]"
//
//        for single in all{
//            guard
//                let event = single.week.filter(string)
//                print(event)
//                else{
//                print("error")
//            }
//        }
//
//
//
//        return subject
//
//    }

    
//    func colourByCell(array: [RepeatingEvent], column: Int, row: Int) -> UIColor{ //get event colour by cell
//        var colour = UIColor()
//        for event in array{
//            for rows in event.occurences[column-1]{
//                if rows == row + 4{
//                    colour = event.colour
//                }
//            }
//        }
//        return colour
//        
//    }
    
    
//    func descByCell(array: [RepeatingEvent], column: Int, row: Int) -> String{ //get event description by cell
//        var desc = ""
//        for event in array{
//            for rows in event.occurences.row{
//                if rows == row + 4{
//                    desc = event.description
//                }
//            }
//        }
//        return desc
//
//    }
    
    
//    func eventByCell(array: [RepeatingEvent], column: Int, row: Int) -> RepeatingEvent{ //get event by cell
//        var event = RepeatingEvent()
//        for item in array{
//            for rows in item.occurences[column-1]{
//                if rows == row + 4{
//                    event = item
//                }
//            }
//        }
//        return event
//    }
//
//
//    func eventByName(array: [RepeatingEvent], name: String) -> RepeatingEvent { //get event by event name
//        var event = RepeatingEvent()
//        for item in array{
//            if item.name == name{
//                event = item
//            }
//        }
//        return event
//    }
//
//
//
}
