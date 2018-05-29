//
//  SignInWaitVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/25/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import Whisper

class SignInWaitVC: UIViewController {
    @IBOutlet weak var activityInidicator: UIActivityIndicatorView!
    
    @IBOutlet weak var waitBGView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityInidicator.startAnimating()
        animateBG()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityInidicator.stopAnimating()
        waitBGView.stopAnimating()
    }
    
    func animateBG(){
        UIView.animate(withDuration: 15, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            let x = -(self.waitBGView.frame.width - self.view.frame.width)
            self.waitBGView.transform = CGAffineTransform(translationX: x, y: 0)
        }) { (true) in
            print("One move complete")
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
