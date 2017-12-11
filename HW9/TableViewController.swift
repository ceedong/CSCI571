//
//  TableViewController.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/15/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit
import Alamofire
import EasyToast
import SwiftyJSON
import SwiftSpinner
import FacebookShare
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit



protocol toTheFirstScreen {
    func favListPassed(data: [String])
}


class TableViewController: UIViewController, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate{

    @IBOutlet weak var changeButton: UIButton!
  
    @IBOutlet weak var forHighcharts: UIActivityIndicatorView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBAction func clickOnFacebook(_ sender: Any) {
        
        
        
//        let scontent = LinkShareContent(url: NSURL(string: "https://developers.facebook.com")! as URL)
//        //  try! ShareDialog.show(from: self, content: content)
//          try! ShareDialog.show(from: self, content: scontent)
      
      webView.stringByEvaluatingJavaScript(from: "getFBURL()")!
    
        highchartTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.finish), userInfo: nil, repeats: true)
        

      
//        try! ShareDialog.show(from: self, content: scontent)
        
//        tryitonce.mode = .native
//        tryitonce.failsOnInvalidData = false
//        tryitonce.completion = {
//            result in
//            print(result)
//        }
      

        
        
        
    }
    
    
     @objc func finish(){
         let urls = webView.stringByEvaluatingJavaScript(from: "getFBURL()")!
        print(urls)
        if (String(urls) != "1"){
        let scontent = LinkShareContent(url: NSURL(string: urls)! as URL)
//            do { let x = try ShareDialog.show(from: self, content: scontent).completion
//               print(x)
            do {
                try ShareDialog.show(from: self, content: scontent, completion: { (result) in
                    switch result {
                    case .success( _): //reflect the states on post or not
                       self.showToastSuccess()
                    case .cancelled, .failed(_):
                        self.showToastFailure()
                    }
                })
 
                
            } catch {
                print("This is not done!")
            }
            //print(x)
           highchartTimer.invalidate()
            }
    }
    
    func showToastSuccess() {
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Shared successfully!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    func showToastFailure() {
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Shared cancelled!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    func showToastError(){
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("The http request is getting an error!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    func failedToLoadData(){
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Failed to load data, please try again later!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    func failedToLoadChart(){
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Failed to load highchart, please try again later!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    @IBOutlet weak var forHighCharts: UIActivityIndicatorView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    let highChartsLabels = ["Price", "SMA", "EMA", "STOCH", "RSI", "ADX", "CCI", "BBANDS", "MACD"]
    var timer = Timer()
    var initialTimer = Timer()
    var highchartTimer = Timer()
    var delayTimer = Timer()
    var symbolPassedOver : String = ""
    var exp1 : String = ""
    // global variables for the table info.
    var stockSymbol : String = ""
    var stockLastPrice : String = ""
    var stockChange : String = ""
    var stockChangePercent : String = ""
    var stockChangeGroup : String = ""
    var stockTimestamp :String = ""
    var stockOpen :String = ""
    var stockClose : String = ""
    var stockRangeLow : String = ""
    var stockRangeHigh : String = ""
    var stockRange : String = ""
    var stockVolume : String = ""
    var checkResult : String = "1"
    let data: [String] = ["Stock Symbol", "Last Price", "Change", "Timestamp", "Open", "Close", "Day's Range", "Volume"]
    var receivedData : [String] = ["", "", "", "", "", "", "", ""]
    var tests = "hehe"
    var stateOfButton : String = "Price"
    var anotherStateOfButton : String = "Price"
   // var imageName : [String] = ["empty_star","filled_star"]
    var flippedNumber : Bool = true
    var favouriteList : [String] = ["", "", "", ""]
    var favListSymbol : [String] = []
    var delegate : toTheFirstScreen?
    
    func starStates(theStates: Bool, symbol: String){
        var isAlreadyStored = false
        let splitText = symbol.components(separatedBy: " -")
        //favouriteList[0] = splitText[0]
        if theStates == true {
             likeImage.image = UIImage(named: "empty_star")
             var indexes = 0
            if (favListSymbol.count != 0){
                for item in favListSymbol{
                    if item == splitText[0]{
                        favListSymbol.remove(at: indexes)
                        break
                    }
                    indexes = indexes + 1
                }
                delegate?.favListPassed(data: favouriteList)
                 dismiss(animated: true, completion: nil)
                print(favListSymbol)
            }
             print(splitText[0])
             print("the states here!")
             print(favListSymbol)
        } else {
            likeImage.image = UIImage(named: "filled_star")
            for item in favListSymbol {
                if item == splitText[0]{
                isAlreadyStored = true
                    break
                }
            }
            if (isAlreadyStored == false){
                favListSymbol.append(splitText[0])}
            
            print(favListSymbol)
            print("aaaaaaaaa")
            delegate?.favListPassed(data: favouriteList)
            dismiss(animated: true, completion: nil)
        }
    }
  
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
//         let rect = CGRect(origin: .zero, size: CGSize(width: 1.5, height: 1.5))
//        forHighCharts.frame = rect
        
       scrollView.contentSize.height = 1000
      
     
        requestData(){(returnData: [String]) -> Void in
            self.receivedData = returnData
            let firstSpace = returnData[2].hasPrefix("-")
            //print(firstSpace)
            if firstSpace == true {
                self.exp1 = "Red_Arrow_Down.png"
             
            } else {
                self.exp1 = "Green_Arrow_Up.png"
              
            }
          
            
        }
        var isAlreadyFav = false
        /////////////////////////
        print(favListSymbol)
        for item in favListSymbol{
            if item == symbolPassedOver.components(separatedBy: " -")[0]{
                isAlreadyFav = true
                break
            }
        }
        if isAlreadyFav == true{
             likeImage.image = UIImage(named: "filled_star")
             flippedNumber = !flippedNumber
        } else {
             likeImage.image = UIImage(named: "empty_star")
        }
       // starStates(theStates: flippedNumber, symbol: symbolPassedOver)
        likeImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        likeImage.addGestureRecognizer(tapRecognizer)
        
        
        //initialize here !!!!! for the picker view part
        self.webView.alpha = 1.0
        changeButton.isEnabled = false
        
        SwiftSpinner.show( "Loading data")
        
        initialTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.retrieveTheJS), userInfo: nil, repeats: false)
      //  retrieveTheJSForOthers(Symbol: "Price")
       
    
        
    }
    @objc func retrieveTheJS(){
        if let jsURL = Bundle.main.url(forResource:  "Price", withExtension: "html", subdirectory: "jscodes") {
            //////////////////////////////////////////////
           // changeButton.isEnabled = true
            let frag = URL(string:"#FRAG_URL", relativeTo: jsURL)!
            let request = URLRequest(url:frag)
            self.webView.delegate = self
            self.webView.loadRequest(request)
        }
    }
    
    @objc func retrieveTheJSError(){
        forHighCharts.stopAnimating()
        initialTimer.invalidate()
        timer.invalidate()
        failedToLoadChart()
    }
    
    @objc func imageTapped(){
        flippedNumber = !flippedNumber
         starStates(theStates: flippedNumber, symbol: symbolPassedOver)
        print(flippedNumber)
    }

  
    func retrieveTheJSForOthers(Symbol : String){
        if let jsURL = Bundle.main.url(forResource:  Symbol, withExtension: "html", subdirectory: "jscodes") {
            ///////////////////////////////////
         //   changeButton.isEnabled = true
            let frag = URL(string:"#FRAG_URL", relativeTo: jsURL)!
            let request = URLRequest(url:frag)
            self.webView.delegate = self
            self.webView.loadRequest(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.label1.text = data[indexPath.row]
        cell.label2.text = receivedData[indexPath.row]
        if indexPath.row == 2 && self.exp1 != "" {
            cell.arrow.image = UIImage(named: exp1)}
        //cell.detailTextLabel?.text = data[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    

    
    
    //callback is used to prevent unexpected async behavior
    func requestData (result : @escaping (_ returnData : [String]) -> Void) {
        var returnData : [String] = ["", "", "", "", "", "", "", ""]
        favouriteList = ["", "", "", ""]
        let searchText = symbolPassedOver
        let splitText = searchText.components(separatedBy: " -")
        favouriteList[0] = splitText[0]
        let url = URL(string: "http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/\(splitText[0])")
        Alamofire.request(url!, method:.get).responseJSON{
            
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
               // print(json)
                if (json["Error Message"] != JSON.null || json["Time Series (Daily)"] == JSON.null){
                    print("Error!")
                    self.failedToLoadData()
                    ///////////////////////////////////
                    self.delayTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.retrieveTheJSError), userInfo: nil, repeats: false)
                    self.changeButton.isUserInteractionEnabled = false
                    self.changeButton.alpha = 0.5
                } else {
                //sort the dictionary elements into an array
               let sortedDict = json["Time Series (Daily)"].sorted {$0.0 > $1.0} as Array
                self.stockSymbol = String(describing: json["Meta Data"]["2. Symbol"]).uppercased()
                self.stockLastPrice = String(describing:sortedDict[0].1["4. close"])
                self.stockOpen = String(describing:sortedDict[0].1["1. open"])
                self.stockClose = String(describing:sortedDict[1].1["4. close"])
                self.stockRangeLow = String(describing:sortedDict[0].1["3. low"])
                self.stockRangeHigh = String(describing:sortedDict[0].1["2. high"])
                self.stockVolume = String(describing:sortedDict[0].1["5. volume"])
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.numberStyle = .decimal
                let formattedNumber = formatter.string(from: Int(self.stockVolume)! as NSNumber)
                self.stockVolume = formattedNumber!
                let tempLastPrice = Double(self.stockLastPrice)!*1000/1000
                let tempOpen = Double(self.stockOpen)!*1000/1000
                let tempClose = Double(self.stockClose)!*1000/1000
                let tempLow = Double(self.stockRangeLow)!*1000/1000
                let tempHigh = Double(self.stockRangeHigh)!*1000/1000
                let tempAnotherPirce = Double(String(describing:sortedDict[1].1["4. close"]))
                let tempChanges = Double(Double(self.stockLastPrice)! - tempAnotherPirce!)
                let tempChange = Double(round(1000*tempChanges)/1000)
                let tempResults = ((Double(self.stockLastPrice)! - tempAnotherPirce!)/tempAnotherPirce!)*100
                let tempPercent = Double(round(100*tempResults)/100)
                let tempTimeStamp = String(describing: json["Meta Data"]["3. Last Refreshed"])
                if (tempTimeStamp.count == 10){
                    self.stockTimestamp = "\(tempTimeStamp) 16:00:00 EST"
                } else {
                    self.stockTimestamp = "\(tempTimeStamp) EST"
                }
                self.stockLastPrice = String(tempLastPrice)
                self.favouriteList[1] = String(tempLastPrice)
                self.stockChangePercent = String(tempPercent)
                self.stockChange = String(tempChange)
                self.stockChangeGroup = "\(self.stockChange) (\(self.stockChangePercent)%)"
                self.favouriteList[2] = self.stockChange
                self.favouriteList[3] = self.stockChangePercent
                self.stockOpen = String(tempOpen)
                self.stockClose = String(tempClose)
                self.stockRangeLow = String(tempLow)
                self.stockRangeHigh = String(tempHigh)
                self.stockRange = "\(self.stockRangeLow) - \(self.stockRangeHigh)"
                
                if response.result.value == nil  {
                    returnData = ["", "", "", "", "", "", "", ""]
                    result(returnData)
                } else {
                
                 returnData = [self.stockSymbol,self.stockLastPrice,self.stockChangeGroup,self.stockTimestamp,self.stockOpen,self.stockClose,self.stockRange,self.stockVolume]
                    
                    
                result(returnData)
                }
                
                }
                
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
                
               SwiftSpinner.hide()
           
                
                
                
            } else {
                self.showToastError()
                print("This is gonna to be a mistake!")
                SwiftSpinner.hide()
            }
        }
        
        
       
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return highChartsLabels[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return highChartsLabels.count
    }
    
    //used later !!!!!!!!!
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        //by default this function is not called so I am gonna change the default and call js to price
        //when click on the button then we should change the view
        stateOfButton = highChartsLabels[row]
        print("---------------")
        print(stateOfButton)
         print("---------------")
        if anotherStateOfButton != stateOfButton {
            changeButton.isEnabled = true} else if anotherStateOfButton == stateOfButton{
            changeButton.isEnabled = false
        }
  
    }
        
        
        
    @IBAction func changeButton(_ sender: Any) {
        
        print("inchangebutton")
        anotherStateOfButton = stateOfButton
        self.webView.alpha = 0.0
        retrieveTheJSForOthers(Symbol: stateOfButton)
        self.webView.alpha = 1.0
        changeButton.isEnabled = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
       NSLog("request111:\(request)")
       
       
        print("startloadwith")
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("I begin loading some stuff in it!")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("didfinishload")
        if (webView.isLoading){
            return
        }
        NSLog("finished loading!")
        loadHighcharts()
    }
    
    private func webView(webView: UIWebView, didFailLoadWithError: Error){
        print("failederror")
        print("Error happened!")
    }
    
    func loadHighcharts(){
        forHighCharts.startAnimating()
        let searchText = symbolPassedOver
        let splitText = searchText.components(separatedBy: " -")
        let params = splitText[0]
        //print(params)
        webView.stringByEvaluatingJavaScript(from: "getTheData('\(params)')")!
        
        //set the timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
       // print(checkResult)
      //  print("loadhighcharts")
       
        
        
        
        
    }
    
    @objc func update(){
         checkResult = webView.stringByEvaluatingJavaScript(from: "getthestates()")!
          print(checkResult)
        if (checkResult == "0"){
            forHighCharts.stopAnimating()
            timer.invalidate()
            initialTimer.invalidate()
        }
        
       // print(checkResult)
    }

    
}
