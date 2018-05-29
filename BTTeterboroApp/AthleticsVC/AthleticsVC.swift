//
//  AthleticsVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/25/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import GSImageViewerController
import PDFReader
import NVActivityIndicatorView

class AthleticsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var athleticsImageView: UIImageView!
    
    @IBOutlet weak var athleticsTableView: UITableView!
    
    @IBAction func imageTapped(_ sender: Any) {
        let imageInfo   = GSImageInfo(image: UIImage(named: "BTAvailableAthleticsDefault")!, imageMode: .aspectFit)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
        navigationController?.pushViewController(imageViewer, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
     
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Athletics"
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "athleticSchedule", for: indexPath)
            return cell
            
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "physicalForm", for: indexPath)
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "healthUpdateQuestions", for: indexPath)
            return cell
            
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 68
        }else if (indexPath.row == 1){
            return 47
        }else{
            return 68
        }
    }
    var formArray = ["https://bergencountytechnicalhighschool.bigteams.com/", "https://app.formreleaf.com/organizations/bergen-county-technical-schools", "https://bcts.bergen.org/images/Athletics/Docs/HealthHistoryUpdate.pdf"]
    
    var selectedForm = String()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0 || indexPath.row == 1){
            self.selectedForm = formArray[indexPath.row]
            self.performSegue(withIdentifier: "athleticVCToSportsFormsVC", sender: self)
            
        }else{
            var actTag = 1802
            
            startBallClipRotatePulseActivityIndicator(itemTag: actTag)
            
            athleticsTableView.isUserInteractionEnabled = false
            
            DispatchQueue.global(qos: .userInitiated).async{
                let remotePDFDocumentURLPath = self.formArray[indexPath.row]
                
                let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
                
                let document = PDFDocument(url: remotePDFDocumentURL)!
                
                DispatchQueue.main.async {
                    
                    let readerController = PDFViewController.createNew(with: document, actionStyle: .activitySheet)
                    
                    self.navigationController?.pushViewController(readerController, animated: true)
                    
                    self.athleticsTableView.isUserInteractionEnabled = true
                    self.stopActivityIndicator(itemTag: actTag)
                }
            }
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "athleticVCToSportsFormsVC"{
            let vc = segue.destination as! AthleticsFormViewer
            vc.link = self.selectedForm
        }
    }

    func startBallClipRotatePulseActivityIndicator(itemTag: Int){
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
