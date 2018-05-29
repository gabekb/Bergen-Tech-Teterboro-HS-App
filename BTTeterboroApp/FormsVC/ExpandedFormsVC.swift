//
//  ExpandedFormsVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/25/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import WebKit
import PDFReader
import NVActivityIndicatorView

class ExpandedFormsVC: UIViewController, WKUIDelegate, WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    var formLink = String()
    var actTag = 9823
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        startBallClipRotateActivityIndicator(itemTag: actTag)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        let url = URL(string: formLink)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url!))
        
        
        
    }
    func openDocInSafari(){
        UIApplication.shared.open(URL(string : "http://www.stackoverflow.com")!, options: [:], completionHandler: { (status) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityIndicator(itemTag: actTag)
    }
    
    
    
    
    
    
    

    
    //ACTIVITY INDICATOR FUNCTIONS

    func startBallClipRotateActivityIndicator(itemTag: Int){
        var frame = CGRect()
        
        frame.size = CGSize(width: 75, height: 75)
        
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white, padding: 20)
        
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.layer.opacity = 0.7
        activityIndicator.tag = itemTag
        
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(itemTag: Int){
        if (view.viewWithTag(itemTag) != nil){
            var x = view.viewWithTag(itemTag) as! NVActivityIndicatorView
            x.stopAnimating()
            x.removeFromSuperview()
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
