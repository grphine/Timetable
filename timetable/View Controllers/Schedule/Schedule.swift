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
    var name = String()
    
    //TODO: Reload schedule on return from event
    //TODO: Add create event button, right nav button - therefore rework how add event works
    

    let dates = ["01/11/18", "02/11/2018", "03/11/2018", "04/11/2018", "05/11/2018", "06/11/2018", "08/11/2018"]
    let days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    let hours = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM",
                 "3:00 PM", "4:00 PM", "5:00PM"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        allDict = addToDictionary(all: allEvents)
        //load data
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
        
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        allDict = addToDictionary(all: allEvents)
        //reload data when view loads
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
            
            let text = getEventName(dict: allDict, column: indexPath.column, row: indexPath.row)
    
            if text != "" {
                cell.label.text = text
                var colour = UIColor()
                
                for event in allEvents{ //get colour for event name
                    if event.name == text{
                        colour = UIColor(hex: event.colour)
                        break
                    }
                }
                
                cell.label.textColor = colour
                cell.color = colour.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 1, color: colour)
                cell.borders.bottom = .solid(width: 1, color: colour)
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            
            //TODO: Populate single events too. After populating with repeating, if there is a conflict with single, make a merged cell or something


            return cell
        }
        return nil
    }
    
    /// Delegate
    
    //MARK: Segueing to EventVC
    //TODO: Fix non selection of locked columns and rows
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {

        //get event and trigger segue
        if (indexPath.column >= 1 || indexPath.row >= 2){ //prevent locked cells performing segue
            name = getEventName(dict: allDict, column: indexPath.column, row: indexPath.row)
            performSegue(withIdentifier: "editEventSegue", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editEventSegue"{
            let destinationVC = segue.destination as! EventVC
            destinationVC.eventName = name //send event name
            //destinationVC.allEvents = allEvents //send dictionary (saves generating again), currently unused
        }
        
    }
    
    func getEventName(dict: [String: [[Int]]], column: Int, row: Int) -> String{
        var name = String()
        whole: for event in dict{ //get event name at cell position
            for hour in event.value[column-1]{
                if hour == (row+4){
                    name = event.key
                    break whole //escapes entire loop once value is found
                }
            }
        }
        
        return name
    }
        
   
    func addToDictionary(all: [RepeatingEvent]) -> [String: [[Int]]]{ //adds all events to a dictionary

        var eventTimes = [String: [[Int]]]()
        
        for event in all{
            var dayHours = [[Int]]()
            
            for day in event.week{
                var hours = [Int]()
                
                for hour in day.dayItem{
                    hours.append(hour.hourItem)
                }
                dayHours.append(hours)
            }
            eventTimes[event.name] = dayHours
        }

        return eventTimes
    }
    
}
