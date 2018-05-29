//
//  THSNewsVC.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/22/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit
import Firebase
import SwiftSoup
import NVActivityIndicatorView

class newsItem {
    var content: String
    var title: String
    var author: String
    var publishedDate: String
    var link: String
    var imageLink: String
    
    init(c:String, t:String, a:String, pD: String, l:String, iL: String) {
        content = c
        title = t
        author = a
        publishedDate = pD
        link = l
        imageLink = iL
    }
}

class THSNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var thsNewsTableView: UITableView!
    
    var newsObjArray = [newsItem]()
    
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var actTag = 1231
        startBallBeatActivityIndicator(itemTag: actTag)
        
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .userInteractive).async{
            self.retrieveTHSNews(completion: {(true) in
                
                self.orderNewsArrayByDate(completion: { (true) in
                    self.thsNewsTableView.reloadData()
                    
                    self.stopActivityIndicator(itemTag: actTag)
                })
            })
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "News"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return newsObjArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "THSNewsCell", for: indexPath) as! THSNewsCell
        
        cell.titleLabel.text = self.newsObjArray[indexPath.row].title
        
        let pubDate = Date.getFormattedDate(d: self.newsObjArray[indexPath.row].publishedDate)
        cell.datePublishedLabel.text = pubDate
        
        
        return cell
    }
    
    
    var selectedTitle = String()
    var selectedContent = String()
    var selectedAuthor = String()
    var selectedPublished = String()
    //var selectedLink = String()
    var selectedImageURL = String()
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var count = 0
        for item in newsObjArray{
            if(indexPath.row == count){
                self.selectedTitle = self.newsObjArray[indexPath.row].title
                self.selectedContent = self.newsObjArray[indexPath.row].content
                self.selectedAuthor = self.newsObjArray[indexPath.row].author
                self.selectedPublished = self.newsObjArray[indexPath.row].publishedDate
                self.selectedImageURL = self.newsObjArray[indexPath.row].imageLink
                
                self.performSegue(withIdentifier: "showMoreNews", sender: self)
                break
            }
            print(count)
        count+=1
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMoreNews"){
            let vc = segue.destination as! THSNewsExpandedVC
            vc.articleTitle = self.selectedTitle
            vc.content = self.selectedContent
            vc.author = self.selectedAuthor
            vc.published = self.selectedPublished
            vc.imageLink = self.selectedImageURL
        }
    }
    
    
    func retrieveTHSNews(completion: @escaping (Bool) -> ()){
        let docRed = db.collection("News")
        docRed.getDocuments { (document, error) in
            if (error != nil){
                print("ERROR: An error occurred fetching the THS NEWS.")
                //Alert here
                return
            }else if let docs = document?.documents{
                for item in docs{
                    
                    var newsContent = String(describing: item.data()["content"]!).html2String
                    
                    var newsTitle = String(describing: item.data()["title"]!).html2String
                    
                    var newsAuthor = String(describing: item.data()["author"]!).html2String
                    
                    var pubDate = String(describing: item.data()["published"]!).html2String
                    
                    var newsLink = String(describing: item.data()["link"]!).html2String
                    
                    
                    
                    do {
                        let html: String = String(describing: item.data()["content"])
                        let doc: Document = try SwiftSoup.parseBodyFragment(html)
                        let body: Element? = doc.body()
                        
                        if try! body!.select("img").first() != nil{
                            let link: Element = try body!.select("img").first()!
                            let linkSRC: String = try link.attr("src");
                            var newsObj = newsItem(c: newsContent, t: newsTitle, a: newsAuthor, pD: pubDate, l: newsLink, iL: linkSRC)
                            self.newsObjArray.append(newsObj)
                        }
                        
                        
                        
                        
                       
                        
                    }catch {
                        print("error")
                    }
                    
                    
                }
                print(self.newsObjArray)
                completion(true)
            }
            
            
        }
        
        
        
        
        
    }
    
    func orderNewsArrayByDate(completion: @escaping (Bool)->()){
        let sortedNewsArray = newsObjArray.sorted(by: { $0.publishedDate.compare($1.publishedDate) == .orderedDescending})
        newsObjArray = sortedNewsArray
        completion(true)
        
    }
    
    func startBallBeatActivityIndicator(itemTag: Int){
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
