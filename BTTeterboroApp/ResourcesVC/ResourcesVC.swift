//
//  ResourcesVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/31/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import WebKit

class ResourcesVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "http://portal.bergen.org/DownPdf/Login.aspx?ReturnUrl=%2fDownPdf%2fDefault.aspx")
        webView.load(URLRequest(url: url!))
        print("Attempting URL Load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Resources"
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
