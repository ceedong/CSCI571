//
//  NewsViewController.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/15/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

//NOTES: THE NEWS PART HAS BEEN COMPLETED ALREADY!!!!

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
  
    @IBOutlet weak var tableView: UITableView!
    
    var returnTitle : [String] = []
    var returnDate : [String] = []
    var returnAuthor : [String] = []
    var returnLink : [String] = []
    var strings = ["1","2","3","4","5"]
    
    
    
    var symbolPassedOver : String = ""
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
label.text = "This area is for news display."
        label.text = symbolPassedOver
       requestData(){(returnData: [String]) -> Void in
        //print(returnData)
        
        }
        // Do any additional setup after loading the view.
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLabel", for: indexPath) as! NewsCell
        
        cell.author.text = returnAuthor[indexPath.row]
        cell.date.text = returnDate[indexPath.row]
        cell.heading.text = returnTitle[indexPath.row]
        cell.heading.numberOfLines = 0
        cell.heading.lineBreakMode = NSLineBreakMode.byWordWrapping
//        cell.author.text = strings[indexPath.row]
//        cell.date.text = strings[indexPath.row]
//        cell.heading.text = strings[indexPath.row]
         return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnDate.count//the number of cells which should be 5 in HW8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let stringURL = returnLink[indexPath.row]
        let newURL = stringURL.replacingOccurrences(of: "\\/", with: "/")
        //print(newURL)
        
        if let requestUrl = URL(string: newURL){
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
        }
        //print(returnLink[indexPath.row])
    }
    
   
    func requestData (result: @escaping (_ returnData : [String]) -> Void) {
       
        
        var returnData : String = ""
        let searchText = symbolPassedOver
        let splitText = searchText.components(separatedBy: " -")
        //print(splitText[0])
        let url = URL(string: "http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/news/\(splitText[0])")
        //print("I am now ready to print the news field for \(splitText[0])")
        Alamofire.request(url!, method:.get).responseJSON{// if not successs please consider return something else
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                
                let items = json["rss"]["channel"][0]["item"]
                for item in items {
                  //  print(item.1["link"])
                    let x = String(describing: item.1["link"])
                    //print(x.contains("article"))

                    if x.contains("article") == true {
                        //convert the url string
                        let y = x.components(separatedBy: "\n  ")
                        let z = y[1].components(separatedBy: "\n")
                        let w = z[0].components(separatedBy: "\"")
                        
                       // print(w[1])
                        //convert the pubDate string
                        let x1 = String(describing: item.1["pubDate"])
                        let y1 = x1.components(separatedBy: "\n  ")
                        let z1 = y1[1].components(separatedBy: "\n")
                        let w1 = z1[0].components(separatedBy: "\"")
                        var n1 = w1[1].components(separatedBy: "-0500")
                        n1[0].append(" PST")
                        //convert the Author string
                        let x2 = String(describing: item.1["sa:author_name"])
                        let y2 = x2.components(separatedBy: "\n  ")
                        let z2 = y2[1].components(separatedBy: "\n")
                        let w2 = z2[0].components(separatedBy: "\"")
                        //convert the Title string
                        let x3 = String(describing: item.1["title"])
                        let y3 = x3.components(separatedBy: "\n  ")
                        let z3 = y3[1].components(separatedBy: "\n")
                        let w3 = z3[0].components(separatedBy: "\"")
                        self.returnLink.append(w[1])
                        self.returnDate.append(n1[0])
                        self.returnAuthor.append(w2[1])
                        self.returnTitle.append(w3[1])
//                        print(String(describing: item.1["link"]))
//                        print(item.1["title"])
//                        print(item.1["pubDate"])
//                        print(item.1["sa:author_name"])
                    }
                    
                    //print("-----------------")
                }
//                print(self.returnLink)
//                print(self.returnTitle)
//                print(self.returnAuthor)
//                print(self.returnDate)
                returnData = "hehehe"
            } else {
                print("The transition failed! Try again later.")
                self.tableView.alpha = 0.0
            }// for the failure part.
            
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.label.text = "Failed to load news data"
            })
            
            
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
