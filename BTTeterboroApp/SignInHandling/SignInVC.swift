//
//  SignInVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/19/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FCAlertView

class SignInVC: UIViewController, GIDSignInUIDelegate, FCAlertViewDelegate{
    @IBOutlet weak var bgView: UIImageView!
    
    @IBAction func dontHaveAccButtonPressed(_ sender: Any) {
        makeFCAlertView(title: "We're sorry", message: "This application can only be used by the students and faculty members of Bergen Tech.", buttons: [])
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: Any) {
        beginSignIn()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animateBG()
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser?.uid != nil {
            
            //user is logged in
            print("A user is logged in")
            
        }else{
            //user is not logged in
            print("A user is not logged in")
        }
        
    }
    func animateBG(){
        UIView.animate(withDuration: 15, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            let x = -(self.bgView.frame.width - self.view.frame.width)
            self.bgView.transform = CGAffineTransform(translationX: x, y: 0)
        }) { (true) in
            print("One move complete")
        }
    }
    func beginSignIn(){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        print("beginning sign in")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func makeFCAlertView(title: String, message: String, buttons: [String]){
        let alert = FCAlertView()
        alert.colorScheme = UIColor(red: 198/255, green: 180/255, blue: 69/255, alpha: 1.0)
        alert.hideDoneButton = false
        alert.delegate = self
        alert.secondButtonBackgroundColor = UIColor(red: 198/255, green: 180/255, blue: 69/255, alpha: 1.0)
        alert.secondButtonTitleColor = UIColor.white
        alert.showAlert(inView: UIApplication.topViewController(),
                        withTitle: title,
                        withSubtitle: message,
                        withCustomImage: UIImage(named: "ExclamationMarkYellow"),
                        withDoneButtonTitle: "Dismiss",
                        andButtons: buttons)
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
