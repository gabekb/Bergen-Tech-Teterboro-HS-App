//
//  THSNewsExpandedVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/22/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import ParallaxHeader
import NVActivityIndicatorView


class THSNewsExpandedVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var contentView: UITextView!
    var imageLink = String()
    var articleTitle = String()
    var content = String()
    var author = String()
    var published = String()

    @IBOutlet weak var dataView: UIView!
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create view as header view
        titleView.text = articleTitle
        contentView.text = content
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        
        
        
        
        scrollView.parallaxHeader.view = imageView
        scrollView.parallaxHeader.height = 400
        scrollView.parallaxHeader.minimumHeight = 0
        scrollView.parallaxHeader.mode = .topFill
        scrollView.delegate = self
        
        var frame = CGRect()

        frame.size = CGSize(width: 75, height: 75)

        //ballTrianglePath

        let activityIndicator = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.darkGray, padding: 20)

        scrollView.parallaxHeader.view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: scrollView.parallaxHeader.view.frame.minY + 200)
        print(scrollView.parallaxHeader.view.frame.maxY)

        activityIndicator.startAnimating()
        
        
        getDataFromUrl(url: URL(string: imageLink)!, completion: { (imageData, response, error) in
            if error != nil{
                print("An error occured: ", error!)
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData!)!
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            
        
            })
        }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if (error != nil){
                completion(data, response, error)
            }
            completion(data, response, error)
            }.resume()
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
