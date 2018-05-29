//
//  HomePageVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/19/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import Firebase
import GoogleSignIn
import Whisper
import UserNotifications

class HomePageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationBarDelegate {

    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if (indexPath.row == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 60/255, green: 53/255, blue: 45/255, alpha: 1.0).cgColor
            
            return cell
            
        }else if (indexPath.row == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 235/255, green: 76/255, blue: 55/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 2){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AthleticsCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 200/255, green: 113/255, blue: 33/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 3){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FormsCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 0/255, green: 83/255, blue: 22/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 4){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourcesCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 76/255, green: 11/255, blue: 71/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 5){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 0/255, green: 142/255, blue: 111/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 6){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PowerSchoolCell", for: indexPath)
            
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 7){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NavianceCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 82/255, green: 188/255, blue: 202/255, alpha: 1.0).cgColor
            return cell
            
        }else if (indexPath.row == 8){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherInfoCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 172/255, green: 9/255, blue: 108/255, alpha: 1.0).cgColor
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCell", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor(red: 232/255, green: 77/255, blue: 56/255, alpha: 1.0).cgColor
            return cell
        }
    }

    var userEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//         Do any additional setup after loading the view.
        
        if(GIDSignIn.sharedInstance().currentUser.profile.email != nil){
            let currentUser = GIDSignIn.sharedInstance().currentUser.profile.email!
            let message = Message(title: "You are signed in as: \(currentUser)", backgroundColor: UIColor(red: 0/255, green: 177/255, blue: 106/255, alpha: 1.0))

            // Show and hide a message after delay
            Whisper.show(whisper: message, to: navigationController!, action: .show)
            
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Whisper.hide(whisperFrom: navigationController!)
        print("Item tapped at indexPath: ", indexPath)
        if (indexPath.row == 0){
            self.performSegue(withIdentifier: "homeToTHSNews", sender: self)
            
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "homeToSchoolCalendar", sender: self)
            
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "homeVCToAthleticsVC", sender: self)
            
        }else if indexPath.row == 3{
            self.performSegue(withIdentifier: "homeToFormsVC", sender: self)
            
        }else if indexPath.row == 4 {
            self.performSegue(withIdentifier: "homeVCToResourcesVC", sender: self)
            
        }else if indexPath.row == 5{
            self.performSegue(withIdentifier: "homeVCToAboutBT", sender: self)
            
        }else if indexPath.row == 6{
            self.performSegue(withIdentifier: "homeToPowerschoolVC", sender: self)
            
        }else if indexPath.row == 7{
            self.performSegue(withIdentifier: "homeToNavianceVC", sender: self)
            
        }else if indexPath.row == 8{
            self.performSegue(withIdentifier: "homeVCToOtherInfoVC", sender: self)
            
        }else if indexPath.row == 9{
            self.performSegue(withIdentifier: "homeVCToNotificationsVC", sender: self)
            
        }
        
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
