//
//  FormsVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/25/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import Firebase
import SwiftSoup
import NVActivityIndicatorView
import PDFReader

class FormsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var formsDisplayTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = CGRect()
        
        frame.size = CGSize(width: 75, height: 75)
        
        //ballTrianglePath
        
        var actTag = 1501
        startBallBeatRotateActivityIndicator(itemTag: actTag)
        
        // Do any additional setup after loading the view.
        retrieveTHSForms { (true) in
            self.formsDisplayTableView.reloadData()
            self.stopActivityIndicator(itemTag: actTag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Forms"
    }
    
    
    var titleArray = [String]()
    var linkArray = [String]()
    
    func retrieveTHSForms(completion: @escaping (Bool) -> ()){
        let formsDoc = db.collection("Forms")
        
        formsDoc.getDocuments { (documents, error) in
            if (error != nil){
                print("ERROR Occurred retrieveing THS Forms: ", error?.localizedDescription)
                return
            }else if let docs = documents?.documents{
                for item in docs{
                    self.titleArray.append(String(describing: item.data()["title"]!))
                    self.linkArray.append(String(describing: item.data()["link"]!))
                    print(item.data()["title"]!)
                    print(item.data()["link"]!)
                    
                }
                completion(true)
            }
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titleArray.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormsTBCell") as! FormsCell
        cell.titleLabel.text = titleArray[indexPath.row]
        
        if linkArray[indexPath.row].range(of: "bcts") != nil{
            cell.iconImageView.image = UIImage(named: "FileIcon")
            
        }else{
            cell.iconImageView.image = UIImage(named: "LinkIcon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var selectedLink = String()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var count = 0
        for item in titleArray{
            if indexPath.row == count{
                selectedLink = linkArray[indexPath.row]
                
                if ((selectedLink.range(of: "bcts") != nil) && (selectedLink.range(of: "pdf") != nil)){
                    
                    let actTag = 1200
                    startBallClipRotateActivityIndicator(itemTag: actTag)
                    
                    print("DispatchQueue for PDF being called")
                    formsDisplayTableView.isUserInteractionEnabled = false
                    DispatchQueue.global(qos: .userInitiated).async {

                        
                        let remotePDFDocumentURLPath = self.selectedLink
                        let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
                        let document = PDFDocument(url: remotePDFDocumentURL)!
                        
                        DispatchQueue.main.async {
                            let readerController = PDFViewController.createNew(with: document, actionStyle: .activitySheet)
                            self.navigationController?.pushViewController(readerController, animated: true)
                            
                            self.formsDisplayTableView.isUserInteractionEnabled = true
                            
                            self.stopActivityIndicator(itemTag: actTag)
                            

                        }
                        
                    }
                    
                }else{
                    self.performSegue(withIdentifier: "formsVCToExpandedForms", sender: self)
                }
                
            }
        count += 1
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formsVCToExpandedForms"{
            let vc = segue.destination as! ExpandedFormsVC
            vc.formLink = selectedLink
        }
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
    
    func startBallBeatRotateActivityIndicator(itemTag: Int){
        var frame = CGRect()
        
        frame.size = CGSize(width: 75, height: 75)
        
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballBeat, color: UIColor.white, padding: 20)
        
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
