//
//  SchoolCalendarVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/24/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import EventKit
import Firebase

class SchoolCalendarVC: UIViewController, CalendarViewDataSource, CalendarViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var eventTableView: UITableView!
    
    var eventTitleArray = [String]()
    var eventStartDateArray = [String]()
    var eventEndDateArray = [String]()
    var eventTypeArray = [String]()
    
    var events = [CalendarEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CalendarView.Style.cellShape = .bevel(8.0)
        CalendarView.Style.cellColorDefault = UIColor.clear
        CalendarView.Style.cellColorToday = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.cellEventColor = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.headerTextColor = UIColor.darkGray
        CalendarView.Style.cellTextColorDefault = UIColor.gray
        CalendarView.Style.cellTextColorToday = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        CalendarView.Style.cellTextColorWeekend = UIColor.lightGray
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        calendarView.backgroundColor = UIColor.white
        
        calendarView.layer.cornerRadius = 8
        calendarView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 219/255, alpha: 1.0).cgColor
        //calendarView.layer.borderWidth = 0.5
        
        //calendarView.layer.borderColor = UIColor.lightGray.cgColor
       
        //calendarView.isUserInteractionEnabled = false
        
        getEventsFromDatabase { (true) in
            self.calendarView.reloadData()
            self.eventTableView.reloadData()
            self.calendarView.reloadData()
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        let today = Date()
        
        let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        
        
        self.calendarView.setDisplayDate(today)
        self.calendarView.selectDate(today)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Calendar"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return eventTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eventCheckArray[indexPath.row] == "Passed"{
            return 0
        }else{
            return 73.47
        }
        
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        
        let sDateObj = dateFormatter.date(from: eventStartDateArray[indexPath.row])
        
        print(sDateObj)
        self.calendarView.selectDate(sDateObj!)
        self.calendarView.setDisplayDate(sDateObj!, animated: true)
        
    }
    
    var daysUntilArray = [Int]()
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarEventCell", for: indexPath) as! CalendarEventCell
        
        cell.eventTitle.text = eventTitleArray[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        
        let sDateObj = dateFormatter.date(from: eventStartDateArray[indexPath.row])
        let currentDate = Date()
        
        var countDown = self.daysBetweenDates(startDate: currentDate, endDate: sDateObj!)
        
        daysUntilArray.append(countDown)
        
        
        
        
        if (countDown > 1){
            cell.eventCountdown.text = String(countDown) + " days until event"
            
            var eventDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: countDown, to: Date(), options: [])!
            var event:CalendarEvent = CalendarEvent(title: eventTitleArray[indexPath.row], startDate: sDateObj!, endDate: sDateObj!)

            events.append(event)
            self.calendarView.events = events
            
            
        }else if countDown == 1{
            cell.eventCountdown.text = "Today"
        }else{
            cell.eventCountdown.text = String("Passed")
            
        }
        
        
        if eventTypeArray[indexPath.row] == "Closed"{
            cell.eventIconView.layer.cornerRadius = cell.eventIconView.frame.height/2
            cell.eventIconView.backgroundColor = UIColor(red: 150/255, green: 40/255, blue: 27/255, alpha: 1.0)
            
            print("Closed Icon")
            
        }else if eventTypeArray[indexPath.row] == "Half"{
            cell.eventIconView.layer.cornerRadius = cell.eventIconView.frame.height/2
            cell.eventIconView.backgroundColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            
        }else if eventTypeArray[indexPath.row] == "Last"{
            cell.eventIconView.layer.cornerRadius = cell.eventIconView.frame.height/2
            cell.eventIconView.backgroundColor = UIColor(red: 249/255, green: 191/255, blue: 59/255, alpha: 1.0)
        }else if eventTypeArray[indexPath.row] == "First"{
            cell.eventIconView.layer.cornerRadius = cell.eventIconView.frame.height/2
            cell.eventIconView.backgroundColor = UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1.0)
        }
        
        
        return cell
    }

    let db = Firestore.firestore()
    
    var eventCheckArray = [String]()
    
    func getEventsFromDatabase(completion: @escaping (Bool) -> ()){
        
        self.eventCheckArray.removeAll()
        
        let calendarEvents = db.collection("Calendar")
        
        calendarEvents.getDocuments { (document, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else if let docs = document?.documents{
                for item in docs{
                    
                    
                    print(String(describing: item.data()))
                    self.eventTitleArray.append(String(describing: item.data()["Title"]!))
                    
                    if (item.data()["EndDate"] == nil){
                   
                        self.eventEndDateArray.append("NA")
                        print("No end date")
                        
                        
                    }else{
                        var eventEndDate = String(describing: item.data()["EndDate"])
                        eventEndDate = eventEndDate.replacingOccurrences(of: ".", with: " ")
                        
                        self.eventEndDateArray.append(eventEndDate)
                        print(eventEndDate)
                        
                    }
                    var eventStartDate = String(describing: item.data()["StartDate"]!)
                    eventStartDate = eventStartDate.replacingOccurrences(of: ".", with: " ")
                    
                    self.eventStartDateArray.append(eventStartDate)
                    
                    self.eventTypeArray.append(String(describing: item.data()["Type"]!))
                    print(eventStartDate)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM dd yyyy"
                    
                    let sDateObj = dateFormatter.date(from: eventStartDate)
                    let currentDate = Date()
                    
                    var countDown = self.daysBetweenDates(startDate: currentDate, endDate: sDateObj!)
                    if countDown >= 1{
                        self.eventCheckArray.append("Not Passed")
                    }else{
                        self.eventCheckArray.append("Passed")
                    }
                    
                }
                completion(true)
            }
        }
    }
    
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = -3
        
        let today = Date()
        
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.month = 12;
        dateComponents.day = -10
        let today = Date()
        
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        print("Did Select: \(date) with \(events.count) events")
        if events.count > 0{
            var eventTitle = events[0].title
            if let index = self.eventTitleArray.index(of: eventTitle){
                let indexPath = IndexPath(row: index, section: 0)
                eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                eventTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }


   
        }
  
    }
    
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        
        return components.day! + 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
