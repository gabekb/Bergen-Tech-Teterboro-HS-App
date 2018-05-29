//
//  PowerSchoolVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/24/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import WebKit

class PowerSchoolVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var psWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        psWebView.navigationDelegate = self

        let url = URL(string: "https://ps01.bergen.org/public/")
        psWebView.load(URLRequest(url: url!))
        psWebView.allowsBackForwardNavigationGestures = true
        UIView.animate(withDuration: 0.35) {
            self.psWebView.scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
