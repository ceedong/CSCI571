//
//  HistoricalViewController.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/15/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoricalViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var forHistoricalCharts: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var timer = Timer()
    var anotherTimer = Timer()
    @IBOutlet weak var reportError: UILabel!
    var symbolPassedOver : String = ""
    override func viewDidLoad() {
        reportError.alpha = 0.0
        let searchText = symbolPassedOver
        let splitText = searchText.components(separatedBy: " -")
        super.viewDidLoad()
        retrieveJS()
        let url = URL(string: "http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/\(splitText[0])")
        Alamofire.request(url!, method:.get).responseJSON{
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                // print(json)
                if (json["Error Message"] != JSON.null){
                    print("Error!")
                    
                    self.anotherTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updated), userInfo: nil, repeats: false)
                    self.timer.invalidate()
                    self.reportError.alpha = 1.0
                    self.webView.alpha = 0.0
                    self.reportError.text = "Failed to load historcial data"
                }
            }}
        
        
        
        // Do any additional setup after loading the view.
    }

    func retrieveJS(){
        
        if let jsURL = Bundle.main.url(forResource: "jquery_historical", withExtension: "html", subdirectory: "jscodes") {
            
            let frag = URL(string:"#FRAG_URL", relativeTo: jsURL)!
            let request = URLRequest(url:frag)
            webView.delegate = self
            webView.loadRequest(request)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        print("I begin loading some stuff in the historcial chart!")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        
        if (webView.isLoading){
            return
        }
        NSLog("finished loading!")
        
        loadHighcharts()
        
        
        //   print("I have finished all the stuff!")
        
        
        
    }
    
    func loadHighcharts(){
        let searchText = symbolPassedOver
        let splitText = searchText.components(separatedBy: " -")
        let params = splitText[0]
        //print(params)
        let checkResult = webView.stringByEvaluatingJavaScript(from: "getTheData('\(params)')")!
        print("\(checkResult)in the historical!!!!!")
        forHistoricalCharts.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
    }
    
    
    @objc func update(){
         let checkResult = webView.stringByEvaluatingJavaScript(from: "getthestates()")!
      //  print(checkResult)
        if (checkResult == "0"){
            forHistoricalCharts.stopAnimating()
            timer.invalidate()
        }
    }

    @objc func updated(){
        self.forHistoricalCharts.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    
    private func webView(webView: UIWebView, didFailLoadWithError: Error){
        print("Error happened!")
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
