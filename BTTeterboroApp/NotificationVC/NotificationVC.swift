//
//  NotificationVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 4/4/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import PopupDialog

class NotificationObject{
    var title: String
    var content: String
    var sentDate: String
    var deliveredTime: String
    
    init(t: String, c: String, d: String, dt: String){
        title = t
        content = c
        sentDate = d
        deliveredTime = dt
    }
}

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notifications = [NotificationObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.reloadData()
        fetchNotifications { (true) in
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNotifications(completion: @escaping (Bool) -> ()){
        let string = "https://onesignal.com/api/v1/notifications?app_id=46dc21e4-34f4-42b2-9e4f-b465a8fb6dba"
        let url = URL(string: string)
        var request = URLRequest(url: url!)
        request.setValue("Basic ZjJjMzdiZjMtOTFlOS00M2I4LWI2YmYtZjNkNGJhODY5ZDFh", forHTTPHeaderField: "Authorization")
        //request.addValue("clientIDhere", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            if error != nil{
                print("An error occured: ", error?.localizedDescription)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let notificationsList = json!["notifications"]!  as? [[String: Any]]
                    for item in notificationsList!{
                        
                        var title = String()
                        var contents = String()
                        var sentDate = String()
                        var deliveredTime = String()
                        
                        if let itemHeadings = item["headings"]! as? [String: Any]{
                            if (itemHeadings.count) > 0{
                                
                                title = itemHeadings["en"] as! String
                            }
                        }
                        if let itemContent = item["contents"]! as? [String: Any]{
                            if itemContent.count > 0{
                                
                                contents = itemContent["en"] as! String
                            }
                        }
                        
                        if let itemSentDate = item["queued_at"]! as? Double{
                            if itemSentDate != nil{
                                print(itemSentDate)
                                let date = Date(timeIntervalSince1970: itemSentDate)
                                
                                let dayTimePeriodFormatter = DateFormatter()
                                dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
                                
                                let dateString = dayTimePeriodFormatter.string(from: date)
                                
                                sentDate = dateString
                                
                            }
                        }
                        
                        if let itemDeliveredTime = item["delivery_time_of_day"]! as? String{
                            if itemDeliveredTime != nil{
                                deliveredTime = itemDeliveredTime
                            }
                        }
                        
                        var notification = NotificationObject(t: title, c: contents, d: sentDate, dt: deliveredTime)
                        self.notifications.append(notification)
                    }
                    completion(true)
                }catch{
                    print("An error occured")
                }
                
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.notificationTitleLabel.text = notifications[indexPath.row].title
        cell.dateRecievedLabel.text = notifications[indexPath.row].sentDate
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.67
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath.row
        
        let title = notifications[indexPath.row].title
        let sentDate = notifications[indexPath.row].sentDate
        let recievedTime = notifications[indexPath.row].deliveredTime
        let message = "Sent at: \(sentDate) @\(recievedTime)\n\n" + notifications[indexPath.row].content
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Dismiss") {
            print("You canceled the car dialog.")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        popup.transitionStyle = .fadeIn
        // Present dialog
        PopupDialogDefaultView.appearance().titleColor = UIColor.black
        PopupDialogDefaultView.appearance().messageColor = UIColor.darkGray
        PopupDialogDefaultView.appearance().titleFont = UIFont.systemFont(ofSize: 21)
        self.present(popup, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
