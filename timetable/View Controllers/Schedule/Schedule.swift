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
    var settings = SettingsStore()
    var hashTable = HashTable()
    var row = 0
    var column = 0 //to send row and column data to event view
    var allDict = [String: [[Int]]]() //hold each event, its days, and occurences per day
    var name = String()
    let formatter = DateFormatter()
    
    var dates = [String]()
    let days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    var hours = [String]()
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    
    @objc func addTapped(){ //funtion called when add button tapped
        name = "" //set to empty to prevent opening last selected cell
        performSegue(withIdentifier: "editEventSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = uiRealm.object(ofType: SettingsStore.self, forPrimaryKey: "1")!
        
        setupTimes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
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
        
        hashTable.populateTable(timeDifference: settings.lowerBound)
        //load data
        
        //MARK: Populate date headers of timetable
        formatter.dateFormat = "dd/MM/yyyy"
        let monday = Date().startOfWeek
        let mondayString = formatter.string(from: monday!)
        dates.append(mondayString)
        
        var currentDate = monday
        for _ in 0...6{
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)
            let dateString = formatter.string(from: nextDate!)
            currentDate = nextDate
            dates.append(dateString)
        }
        
    }
    
    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimes()
        spreadsheetView.flashScrollIndicators()
        
        allEvents = uiRealm.objects(RepeatingEvent.self).toArray() as! [RepeatingEvent]
        allDict = allEvents.addToDictionary()
        
        //reload times
        
        self.spreadsheetView.reloadData()
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
            
            let text = hashTable.idAtPosition(column: indexPath.column-1, row: indexPath.row+(settings.lowerBound)-2)
    
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
            return cell
        }
        return nil
    }
    
    /// Delegate
    
    //MARK: Segueing to EventVC
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.column > 0 && indexPath.row > 1){ //prevent locked cells performing segue
            name = hashTable.idAtPosition(column: indexPath.column-1, row: indexPath.row+(settings.lowerBound)-2)
            if name != ""{ //prevent empty cells
                performSegue(withIdentifier: "editEventSegue", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editEventSegue"{
            let destinationVC = segue.destination as! EventVC
            destinationVC.eventName = name //send event name
        }
        
    }
    
    func setupTimes(){
        hours = []
        if settings.twentyFour == true{
            //generate 24 hour times
            for x in settings.lowerBound...settings.upperBound{
                var string = ""
                if x < 12{
                    string = "0\(x):00"
                }
                else{
                    string = "\(x):00"
                }
                hours.append(string)
            }
        }
        else{
            //generate 12 hour times
            for x in settings.lowerBound...settings.upperBound{
                var string = ""
                if x < 12{
                    if x == 0{
                        string = "12:00am"
                    }
                    else{
                        string = "\(x):00am"
                    }
                }
                else{
                    if x != 12{
                        string = "\(x-12):00pm"
                    }
                    else{ string = "12:00pm"}
                }
                hours.append(string)
            }
        }
    }
    
    
}
