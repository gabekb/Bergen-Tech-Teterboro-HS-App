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
        
        getEventsFromDatabase { (true) in
            eventTableView.reloadData()
            calendarView.reloadData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        let today = Date()
        
        let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        self.calendarView.selectDate(tomorrow)
        
        self.calendarView.setDisplayDate(today)
        
        var event:CalendarEvent = CalendarEvent(title: "Test", startDate: Date(), endDate: Date())
        var events = [CalendarEvent]()
        print(event.startDate)
        events.append(event)
        self.calendarView.events = events
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
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! CalendarEventCell
        
        cell.eventTitle.text = eventTitleArray[indexPath.row]
        if eventStartDateArray[indexPath.row] != "NA"{
            var countDown = daysBetweenDates(startDate: eventStartDateArray[indexPath.row] as! Date, endDate: eventEndDateArray[indexPath.row] as! Date)
            cell.eventCountdown.text = String(countDown)
        }
        
        
        return cell
    }

    let db = Firestore.firestore()
    func getEventsFromDatabase(completion: @escaping (Bool) -> ()){
        let calendarEvents = db.collection("Calendar")
        calendarEvents.getDocuments { (document, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else if let docs = document?.documents{
                for item in docs{
                    
                    print(String(describing: item.data()))
                    self.eventTitleArray.append(String(describing: item.data()["Title"]))
                    
                    if (item.data()["EndDate"] == nil){
                   
                        self.eventEndDateArray.append("NA")
                        print("No end date")
                        
                        
                    }else{
                        var eventEndDate = String(describing: item.data()["EndDate"])
                        eventEndDate = eventEndDate.replacingOccurrences(of: ".", with: " ")
                        
                        self.eventEndDateArray.append(eventEndDate)
                        print(eventEndDate)
                        
                    }
                    var eventStartDate = String(describing: item.data()["StartDate"])
                    eventStartDate = eventStartDate.replacingOccurrences(of: ".", with: " ")
                    
                    self.eventStartDateArray.append(eventStartDate)
                    print(eventStartDate)
                    
                }
                
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
        
        dateComponents.month = 2;
        dateComponents.day = -10
        let today = Date()
        
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        print("Did Select: \(date) with \(events.count) events")
        
    }
    
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
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
