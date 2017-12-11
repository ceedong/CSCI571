//
//  ViewController.swift
//  cs571-hw9
//
//  Created by Mark Dong on 11/13/17.
//  Copyright © 2017 Mark Dong. All rights reserved.
//

import UIKit
import EasyToast
import SearchTextField
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, goToTheFirstScreenFinal  {
    @IBOutlet weak var order: UIPickerView!
    @IBOutlet weak var sortBy: UIPickerView!
    @IBOutlet weak var acronymTextField: SearchTextField!
    @IBOutlet weak var favListTable: UITableView!
     var timer = Timer()
    
    @IBAction func forAutoRefresh(_ sender: UISwitch) {
        
        
        if (sender.isOn == true){
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.refreshed1), userInfo: nil, repeats: false)
            Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.refreshed1), userInfo: nil, repeats: false)
           } else {
            //invalidated()
            print("The button is not working at all!")
        }
    }
    

    func failedToLoadData(){
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Failed to load data, please try again later!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    
    @IBOutlet weak var favList: UIActivityIndicatorView!
    
    @IBAction func getQuoteValidation(_ sender: UIButton) {
        if (acronymTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
       showToast()
       acronymTextField.text = ""
        } else {
            performSegue(withIdentifier: "goToSecondScreen", sender: self)
        }
    }
    
   
    @IBOutlet weak var refresh: UIImageView!
    
    
    var sortByStrings : [String] = ["Default", "Symbol", "Price", "Change", "Change(%)"]
    var orderString : [String] = ["Ascending", "Descending"]
    var favListSymbol : [String] = []
    var favListLastPrice : [String] = []
    var favListChange : [String] = []
    var favListChangePercent : [String] = []
    var defaultFavSymbol : [String] = []
    var defaultFavLastPrice : [String] = []
    var defaultFavChange : [String] = []
    var defaultFavChangePercent : [String] = []
    var defaultCount = 0
    var ascendingOrDescending = true
    var sortByTag = 0
    @IBAction func clearPressed(_ sender: Any) {
        acronymTextField.text = ""
    }
    @objc func refreshTapped(){
       // print("The refresh button is pressed!")
       // print(favListSymbol)
        refreshed(params: favListSymbol)
    }
    
    func refreshed(params: [String]){
        var dicForLastPrice = [String : String]()
        var dicForChange = [String : String]()
        var dicForChangePercent = [String : String]()
        var length = 0
        var lengthForChange = 0
        var lengthForChangePercent = 0
        var refreshedTable = [[String : String]]()
        for item in favListLastPrice{
            dicForLastPrice[favListSymbol[length]] = item
            length = length + 1
        }
        for item in favListChange{
            dicForChange[favListSymbol[lengthForChange]] = item
            lengthForChange = lengthForChange + 1
        }
        for item in favListChangePercent{
            dicForChangePercent[favListSymbol[lengthForChangePercent]] = item
            lengthForChangePercent = lengthForChangePercent + 1
        }
        print(dicForLastPrice)
        print(dicForChange)
        print(dicForChangePercent)
        print(favListSymbol)
        for item in favListSymbol{
            self.favList.startAnimating()
            let url = URL(string: "http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/\(item)")
            Alamofire.request(url!, method:.get).responseJSON{
                response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    if (json["Error Message"] != JSON.null || json["Time Series (Daily)"] == JSON.null){
                        print("Error!")
                        self.failedToLoadData()
                        ///////////////////////////////////
                        self.favList.stopAnimating()
                    } else {
                    print(json["Meta Data"])
                    let sortedDict = json["Time Series (Daily)"].sorted {$0.0 > $1.0} as Array
                    let stockLastPrice = String(describing:sortedDict[0].1["4. close"])
                    _ = String(describing:sortedDict[1].1["4. close"])
                    let tempLastPrice = Double(stockLastPrice)!*1000/1000
                    let tempAnotherPirce = Double(String(describing:sortedDict[1].1["4. close"]))
                    let tempChanges = Double(Double(stockLastPrice)! - tempAnotherPirce!)
                    let tempChange = Double(round(1000*tempChanges)/1000)
                    let tempResults = ((Double(stockLastPrice)! - tempAnotherPirce!)/tempAnotherPirce!)*100
                    let tempPercent = Double(round(100*tempResults)/100)
                    let lastPriceResult = String(tempLastPrice)
                    let changeResult = String(tempChange)
                    let changePercentResult = String(tempPercent)
                   
                    refreshedTable.append(["symbol" : String(describing: json["Meta Data"]["2. Symbol"]).uppercased(), "lastPrice" : lastPriceResult, "change" : changeResult, "changePercent" : changePercentResult])
                    print("----------------------")
                    print(refreshedTable)
                    print("----------------------")
                    for item in self.favListSymbol{
                        if item == String(describing: json["Meta Data"]["2. Symbol"]).uppercased(){
                            print(item)
                            print(changeResult, changePercentResult)
                            dicForLastPrice[item] = lastPriceResult
                            dicForChange[item] = changeResult
                            dicForChangePercent[item] = changePercentResult
                            var priceCount = 0
                            var changeCount = 0
                            var changePercent = 0
                            for _ in self.favListLastPrice{
                                self.favListLastPrice[priceCount] = dicForLastPrice[self.favListSymbol[priceCount]]!
                                priceCount = priceCount + 1
                            }
                            for _ in self.favListChange{
                                self.favListChange[changeCount] = dicForChange[self.favListSymbol[changeCount]]!
                                changeCount = changeCount + 1
                            }
                            for _ in self.favListChangePercent{
                                self.favListChangePercent[changePercent] = dicForChangePercent[self.favListSymbol[changePercent]]!
                                changePercent = changePercent + 1
                            }
                            self.favListTable.reloadData()
                            self.favList.stopAnimating()
                        }
                    }
                }
            }
        }
    }
       
      //  print(favListSymbol)
      
        
    }
    
    @objc func refreshed1(){
        let params = favListSymbol
        var dicForLastPrice = [String : String]()
        var dicForChange = [String : String]()
        var dicForChangePercent = [String : String]()
        var length = 0
        var lengthForChange = 0
        var lengthForChangePercent = 0
        var refreshedTable = [[String : String]]()
        for item in favListLastPrice{
            dicForLastPrice[favListSymbol[length]] = item
            length = length + 1
        }
        for item in favListChange{
            dicForChange[favListSymbol[lengthForChange]] = item
            lengthForChange = lengthForChange + 1
        }
        for item in favListChangePercent{
            dicForChangePercent[favListSymbol[lengthForChangePercent]] = item
            lengthForChangePercent = lengthForChangePercent + 1
        }
        print(dicForLastPrice)
        print(dicForChange)
        print(dicForChangePercent)
        print(favListSymbol)
        for item in favListSymbol{
            self.favList.startAnimating()
            let url = URL(string: "http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/\(item)")
            Alamofire.request(url!, method:.get).responseJSON{
                response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    if (json["Error Message"] != JSON.null || json["Time Series (Daily)"] == JSON.null){
                        print("Error!")
                        self.failedToLoadData()
                        ///////////////////////////////////
                        self.favList.stopAnimating()
                    } else {

                    print(json["Meta Data"])
                    let sortedDict = json["Time Series (Daily)"].sorted {$0.0 > $1.0} as Array
                    let stockLastPrice = String(describing:sortedDict[0].1["4. close"])
                    _ = String(describing:sortedDict[1].1["4. close"])
                    let tempLastPrice = Double(stockLastPrice)!*1000/1000
                    let tempAnotherPirce = Double(String(describing:sortedDict[1].1["4. close"]))
                    let tempChanges = Double(Double(stockLastPrice)! - tempAnotherPirce!)
                    let tempChange = Double(round(1000*tempChanges)/1000)
                    let tempResults = ((Double(stockLastPrice)! - tempAnotherPirce!)/tempAnotherPirce!)*100
                    let tempPercent = Double(round(100*tempResults)/100)
                    let lastPriceResult = String(tempLastPrice)
                    let changeResult = String(tempChange)
                    let changePercentResult = String(tempPercent)
                    
                    refreshedTable.append(["symbol" : String(describing: json["Meta Data"]["2. Symbol"]).uppercased(), "lastPrice" : lastPriceResult, "change" : changeResult, "changePercent" : changePercentResult])
                    print("----------------------")
                    print(refreshedTable)
                    print("----------------------")
                    for item in self.favListSymbol{
                        if item == String(describing: json["Meta Data"]["2. Symbol"]).uppercased(){
                            print(item)
                            print(changeResult, changePercentResult)
                            dicForLastPrice[item] = lastPriceResult
                            dicForChange[item] = changeResult
                            dicForChangePercent[item] = changePercentResult
                            var priceCount = 0
                            var changeCount = 0
                            var changePercent = 0
                            for _ in self.favListLastPrice{
                                self.favListLastPrice[priceCount] = dicForLastPrice[self.favListSymbol[priceCount]]!
                                priceCount = priceCount + 1
                            }
                            for _ in self.favListChange{
                                self.favListChange[changeCount] = dicForChange[self.favListSymbol[changeCount]]!
                                changeCount = changeCount + 1
                            }
                            for _ in self.favListChangePercent{
                                self.favListChangePercent[changePercent] = dicForChangePercent[self.favListSymbol[changePercent]]!
                                changePercent = changePercent + 1
                            }
                            self.favListTable.reloadData()
                            self.favList.stopAnimating()
                        }
                    }
                }
                }
            }
            
        }
        
        //  print(favListSymbol)
        
        
    }
    
    override func viewDidLoad() {
        favList.stopAnimating()
        super.viewDidLoad()
        order.isUserInteractionEnabled = false
        order.alpha = 0.5
        refresh.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshTapped))
        refresh.addGestureRecognizer(tapRecognizer)
        //  2 - Configure a custom search text field
       // do not present the nav bar on the homepage
        self.navigationController?.isNavigationBarHidden = true
        //initialize all the mistake msgs
        EasyToastConfiguration.toastInnerPadding = 10
        EasyToastConfiguration.animationDuration = 0.6
        EasyToastConfiguration.initialSpringVelocity = 0.07
        EasyToastConfiguration.dampingRatio = 0.65
        configureCustomSearchTextField()
        
        //default value for the picker
        order.tag = 0
        sortBy.tag = 1
        refreshed(params: favListSymbol)
    }
    // present the nav bar on the second page
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    // do not present the nav bar on the first page again
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        refreshed(params: favListSymbol)
    }

    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        acronymTextField.theme = SearchTextFieldTheme.lightTheme()

        // Modify current theme properties
        acronymTextField.theme.font = UIFont.systemFont(ofSize: 12)
        acronymTextField.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.2)
        acronymTextField.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        acronymTextField.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        acronymTextField.theme.cellHeight = 40
        acronymTextField.theme.placeholderColor = UIColor.lightGray

        // Max number of results - Default: No limit
        acronymTextField.maxNumberOfResults = 5

        // Max results list height - Default: No limit
        acronymTextField.maxResultsListHeight = 200

        // Set specific comparision options - Default: .caseInsensitive
        acronymTextField.comparisonOptions = [.caseInsensitive]

        // You can force the results list to support RTL languages - Default: false
        acronymTextField.forceRightToLeft = false

        // Customize highlight attributes - Default: Bold
        //acronymTextField.highlightAttributes = [NSAttributedStringKey.backgroundColor: UIColor.yellow, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]

        // Handle item selection - Default behaviour: item title set to the text field
        acronymTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
           // print("Item at position \(itemPosition): \(item.title)")

            // Do whatever you want with the picked item
            self.acronymTextField.text = item.title
        }

        // Update data source when the user stops typing
        acronymTextField.userStoppedTypingHandler = {
            if let criteria = self.acronymTextField.text {
                if criteria.count > 0 && !((self.acronymTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) && criteria.count < 6{

                    // Show loading indicator
                   // self.acronymTextField.showLoadingIndicator()

                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.acronymTextField.filterItems(results)

                        // Stop loading indicator
                        self.acronymTextField.stopLoadingIndicator()
                    }
                }
            }
            } as (() -> Void)
    }

    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // Data Sources

    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
        var results = [SearchTextFieldItem]()
    
        let url = URL(string: "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=\(criteria)")
       
        Alamofire.request(url!, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                for (_, items) in json{
                    results.append(SearchTextFieldItem(title:  "\(items["Symbol"]) - \(items["Name"]) \(items["Exchange"])" ))
                }
                if response.result.value != nil{
                    DispatchQueue.main.async{
                        callback(results)
                    }
                } else {
                    DispatchQueue.main.async{
                        callback([])
                    }
                }
            } else {
                print("Error happended!")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if acronymTextField.text != "" {
        if segue.identifier == "goToSecondScreen"  {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.textPassedOver = acronymTextField.text!
            destinationVC.symbolPassedOver = favListSymbol
            destinationVC.delegate = self
            dismiss(animated: true, completion: nil)
             }
        }

    }
    
    func showToast() {
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.toastTextColor = UIColor.white
        self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
        self.view.showToast("Please enter a stock name or symbol", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
    }
    
    //for the sortBy pickers and order pickers
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var theNumber : Int = 0
        if pickerView == sortBy {
            theNumber = sortByStrings.count
        }
        else if pickerView == order{
            theNumber = orderString.count
        }
        return theNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var theString : String = ""
        if pickerView == sortBy{
            theString = sortByStrings[row]
        } else if pickerView == order{
           theString = orderString[row]
        }
        return theString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sortBy{
            //print("For the first picker view")
           // print(sortByStrings[row])
            //store the data in case of using default settings
         //print(pickerView.tag)
            
            
           if sortByStrings[row] == "Symbol"{
            order.isUserInteractionEnabled = true
            order.alpha = 1
            sortByTag = 1
            var dicForLastPrice = [String : String]()
            var dicForChange = [String : String]()
            var dicForChangePercent = [String : String]()
            var length = 0
            var lengthForChange = 0
            var lengthForChangePercent = 0
            //print(favListSymbol)
            for item in favListLastPrice{
                dicForLastPrice[favListSymbol[length]] = item
                length = length + 1
            }
            for item in favListChange{
                dicForChange[favListSymbol[lengthForChange]] = item
                lengthForChange = lengthForChange + 1
            }
            for item in favListChangePercent{
                dicForChangePercent[favListSymbol[lengthForChangePercent]] = item
                lengthForChangePercent = lengthForChangePercent + 1
            }
//            print(dicForLastPrice)
//            print(dicForChange)
//            print(dicForChangePercent)
            if ascendingOrDescending == true{
                favListSymbol = favListSymbol.sorted()}
            else if ascendingOrDescending == false{
                favListSymbol = favListSymbol.sorted().reversed()
            }
            var priceCount = 0
            var changeCount = 0
            var changePercent = 0
            for _ in favListLastPrice{
                favListLastPrice[priceCount] = dicForLastPrice[favListSymbol[priceCount]]!
                priceCount = priceCount + 1
            }
            for _ in favListChange{
                favListChange[changeCount] = dicForChange[favListSymbol[changeCount]]!
                changeCount = changeCount + 1
            }
            for _ in favListChangePercent{
                favListChangePercent[changePercent] = dicForChangePercent[favListSymbol[changePercent]]!
                changePercent = changePercent + 1
            }
           } else if sortByStrings[row] == "Price"{
            order.alpha = 1
            order.isUserInteractionEnabled = true
            sortByTag = 2
            var dicForSymbol = [String : String]()
            var dicForChange = [String : String]()
            var dicForChangePercent = [String : String]()
            var length = 0
            var lengthForChange = 0
            var lengthForChangePercent = 0
            for item in favListSymbol{
                dicForSymbol[favListLastPrice[length]] = item
                length = length + 1
            }
            for item in favListChange{
                dicForChange[favListLastPrice[lengthForChange]] = item
                lengthForChange = lengthForChange + 1
            }
            for item in favListChangePercent{
                dicForChangePercent[favListLastPrice[lengthForChangePercent]] = item
                lengthForChangePercent = lengthForChangePercent + 1
            }
//            print(dicForSymbol)
//            print(dicForChange)
//            print(dicForChangePercent)
            if ascendingOrDescending == true{
//                favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedAscending}
                favListLastPrice = favListLastPrice.sorted()
            } else if ascendingOrDescending == false{
//                 favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                 favListLastPrice = favListLastPrice.sorted().reversed()
            }
//            print(favListLastPrice)
            var symbolCount = 0
            var changeCount = 0
            var changePercent = 0
            for _ in favListSymbol{
                favListSymbol[symbolCount] = dicForSymbol[favListLastPrice[symbolCount]]!
                symbolCount = symbolCount + 1
            }
            for _ in favListChange{
                favListChange[changeCount] = dicForChange[favListLastPrice[changeCount]]!
                changeCount = changeCount + 1
            }
            for _ in favListChangePercent{
                favListChangePercent[changePercent] = dicForChangePercent[favListLastPrice[changePercent]]!
                changePercent = changePercent + 1
            }
            
           } else if sortByStrings[row] == "Change"{
            order.alpha = 1
            order.isUserInteractionEnabled = true
            sortByTag = 3
            var dicForSymbol = [String : String]()
            var dicForLastPrice = [String : String]()
            var dicForChangePercent = [String : String]()
            var length = 0
            var lengthForLastPrice = 0
            var lengthForChangePercent = 0
            for item in favListSymbol{
                dicForSymbol[favListChange[length]] = item
                length = length + 1
            }
            for item in favListLastPrice{
                dicForLastPrice[favListChange[lengthForLastPrice]] = item
                lengthForLastPrice = lengthForLastPrice + 1
            }
            for item in favListChangePercent{
                dicForChangePercent[favListChange[lengthForChangePercent]] = item
                lengthForChangePercent = lengthForChangePercent + 1
            }
//            print(dicForSymbol)
//            print(dicForLastPrice)
//            print(dicForChangePercent)
            if ascendingOrDescending == true{
               // favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedAscending}
                favListChange = favListChange.sorted()
            } else if ascendingOrDescending == false{
              //  favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                favListChange = favListChange.sorted().reversed()
            }
//            print(favListChange)
            var symbolCount = 0
            var lastPriceCount = 0
            var changePercent = 0
            for _ in favListSymbol{
                favListSymbol[symbolCount] = dicForSymbol[favListChange[symbolCount]]!
                symbolCount = symbolCount + 1
            }
            for _ in favListLastPrice{
                favListLastPrice[lastPriceCount] = dicForLastPrice[favListChange[lastPriceCount]]!
                lastPriceCount = lastPriceCount + 1
            }
            for _ in favListChangePercent{
                favListChangePercent[changePercent] = dicForChangePercent[favListChange[changePercent]]!
                changePercent = changePercent + 1
            }
            //print("Change")
           } else if sortByStrings[row] == "Change(%)"{
            order.alpha = 1
            order.isUserInteractionEnabled = true
            sortByTag = 4
            var dicForSymbol = [String : String]()
            var dicForLastPrice = [String : String]()
            var dicForChange = [String : String]()
            var length = 0
            var lengthForLastPrice = 0
            var lengthForChange = 0
            for item in favListSymbol{
                dicForSymbol[favListChangePercent[length]] = item
                length = length + 1
            }
            for item in favListLastPrice{
                dicForLastPrice[favListChangePercent[lengthForLastPrice]] = item
                lengthForLastPrice = lengthForLastPrice + 1
            }
            for item in favListChange{
                dicForChange[favListChangePercent[lengthForChange]] = item
                lengthForChange = lengthForChange + 1
            }
//            print(dicForSymbol)
//            print(dicForLastPrice)
//            print(dicForChange)
            if ascendingOrDescending == true { favListChangePercent = favListChangePercent.sorted{$0.localizedStandardCompare($1) == .orderedAscending}}
            else if ascendingOrDescending == false{
                favListChangePercent = favListChangePercent.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
            }
//            print(favListChangePercent)
            var symbolCount = 0
            var lastPriceCount = 0
            var changeCount = 0
            for _ in favListSymbol{
                favListSymbol[symbolCount] = dicForSymbol[favListChangePercent[symbolCount]]!
                symbolCount = symbolCount + 1
            }
            for _ in favListLastPrice{
                favListLastPrice[lastPriceCount] = dicForLastPrice[favListChangePercent[lastPriceCount]]!
                lastPriceCount = lastPriceCount + 1
            }
            for _ in favListChange{
                favListChange[changeCount] = dicForChange[favListChangePercent[changeCount]]!
                changeCount = changeCount + 1
            }
            
            
            // print("Change(%)")
           } else if sortByStrings[row] == "Default"{
            order.alpha = 0.5
            order.isUserInteractionEnabled = false
            sortByTag = 0
            if defaultCount == 0{
            defaultFavSymbol = favListSymbol
            defaultFavLastPrice = favListLastPrice
            defaultFavChange = favListChange
            defaultFavChangePercent = favListChangePercent
            defaultCount = defaultCount + 1
                print("got tricked!")
            }
            else{
                favListSymbol = defaultFavSymbol
                favListLastPrice = defaultFavLastPrice
                favListChange = defaultFavChange
                favListChangePercent = defaultFavChangePercent
            }
            }
            
        } else if pickerView == order{
            order.isUserInteractionEnabled = true
            order.alpha = 1.0
//            print("For the second picker view")
            if orderString[row] == "Ascending"{
                ascendingOrDescending = true
                if sortByTag == 0 {
                    //
                }else if sortByTag == 1{
                 
               
                    var dicForLastPrice = [String : String]()
                    var dicForChange = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForChange = 0
                    var lengthForChangePercent = 0
                    print(favListSymbol)
                    for item in favListLastPrice{
                        dicForLastPrice[favListSymbol[length]] = item
                        length = length + 1
                    }
                    for item in favListChange{
                        dicForChange[favListSymbol[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListSymbol[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
//                    print(dicForLastPrice)
//                    print(dicForChange)
//                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListSymbol = favListSymbol.sorted()}
                    else if ascendingOrDescending == false{
                        favListSymbol = favListSymbol.sorted().reversed()
                    }
                    var priceCount = 0
                    var changeCount = 0
                    var changePercent = 0
                    for _ in favListLastPrice{
                        favListLastPrice[priceCount] = dicForLastPrice[favListSymbol[priceCount]]!
                        priceCount = priceCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListSymbol[changeCount]]!
                        changeCount = changeCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListSymbol[changePercent]]!
                        changePercent = changePercent + 1
                    }
                    
                    
                }else if sortByTag == 2{
                    var dicForSymbol = [String : String]()
                    var dicForChange = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForChange = 0
                    var lengthForChangePercent = 0
                    for item in favListSymbol{
                        dicForSymbol[favListLastPrice[length]] = item
                        length = length + 1
                    }
                    for item in favListChange{
                        dicForChange[favListLastPrice[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListLastPrice[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
                    print(dicForSymbol)
                    print(dicForChange)
                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedAscending}} else if ascendingOrDescending == false{
                        favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                    }
                    print(favListLastPrice)
                    var symbolCount = 0
                    var changeCount = 0
                    var changePercent = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListLastPrice[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListLastPrice[changeCount]]!
                        changeCount = changeCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListLastPrice[changePercent]]!
                        changePercent = changePercent + 1
                    }
                }else if sortByTag == 3{
                   
                    var dicForSymbol = [String : String]()
                    var dicForLastPrice = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForLastPrice = 0
                    var lengthForChangePercent = 0
                    for item in favListSymbol{
                        dicForSymbol[favListChange[length]] = item
                        length = length + 1
                    }
                    for item in favListLastPrice{
                        dicForLastPrice[favListChange[lengthForLastPrice]] = item
                        lengthForLastPrice = lengthForLastPrice + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListChange[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
                    print(dicForSymbol)
                    print(dicForLastPrice)
                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedAscending}} else if ascendingOrDescending == false{
                        favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                    }
                    print(favListChange)
                    var symbolCount = 0
                    var lastPriceCount = 0
                    var changePercent = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListChange[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListLastPrice{
                        favListLastPrice[lastPriceCount] = dicForLastPrice[favListChange[lastPriceCount]]!
                        lastPriceCount = lastPriceCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListChange[changePercent]]!
                        changePercent = changePercent + 1
                    }
                    
                    
                }else if sortByTag == 4{
                    var dicForSymbol = [String : String]()
                    var dicForLastPrice = [String : String]()
                    var dicForChange = [String : String]()
                    var length = 0
                    var lengthForLastPrice = 0
                    var lengthForChange = 0
                    for item in favListSymbol{
                        dicForSymbol[favListChangePercent[length]] = item
                        length = length + 1
                    }
                    for item in favListLastPrice{
                        dicForLastPrice[favListChangePercent[lengthForLastPrice]] = item
                        lengthForLastPrice = lengthForLastPrice + 1
                    }
                    for item in favListChange{
                        dicForChange[favListChangePercent[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    print(dicForSymbol)
                    print(dicForLastPrice)
                    print(dicForChange)
                    if ascendingOrDescending == true { favListChangePercent = favListChangePercent.sorted{$0.localizedStandardCompare($1) == .orderedAscending}}
                    else if ascendingOrDescending == false{
                        favListChangePercent = favListChangePercent.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                    }
                    print(favListChangePercent)
                    var symbolCount = 0
                    var lastPriceCount = 0
                    var changeCount = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListChangePercent[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListLastPrice{
                        favListLastPrice[lastPriceCount] = dicForLastPrice[favListChangePercent[lastPriceCount]]!
                        lastPriceCount = lastPriceCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListChangePercent[changeCount]]!
                        changeCount = changeCount + 1
                    }
                }
                
                
                
                
            } else if orderString[row] == "Descending"{
                ascendingOrDescending = false
                if sortByTag == 0 {
                    //
                }else if sortByTag == 1{
                    
                    var dicForLastPrice = [String : String]()
                    var dicForChange = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForChange = 0
                    var lengthForChangePercent = 0
                    print(favListSymbol)
                    for item in favListLastPrice{
                        dicForLastPrice[favListSymbol[length]] = item
                        length = length + 1
                    }
                    for item in favListChange{
                        dicForChange[favListSymbol[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListSymbol[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
                    print(dicForLastPrice)
                    print(dicForChange)
                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListSymbol = favListSymbol.sorted()}
                    else if ascendingOrDescending == false{
                        favListSymbol = favListSymbol.sorted().reversed()
                    }
                    var priceCount = 0
                    var changeCount = 0
                    var changePercent = 0
                    for _ in favListLastPrice{
                        favListLastPrice[priceCount] = dicForLastPrice[favListSymbol[priceCount]]!
                        priceCount = priceCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListSymbol[changeCount]]!
                        changeCount = changeCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListSymbol[changePercent]]!
                        changePercent = changePercent + 1
                    }
                    
                    
                }else if sortByTag == 2{
                    var dicForSymbol = [String : String]()
                    var dicForChange = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForChange = 0
                    var lengthForChangePercent = 0
                    for item in favListSymbol{
                        dicForSymbol[favListLastPrice[length]] = item
                        length = length + 1
                    }
                    for item in favListChange{
                        dicForChange[favListLastPrice[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListLastPrice[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
                    print(dicForSymbol)
                    print(dicForChange)
                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedAscending}} else if ascendingOrDescending == false{
                        favListLastPrice = favListLastPrice.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                    }
                    print(favListLastPrice)
                    var symbolCount = 0
                    var changeCount = 0
                    var changePercent = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListLastPrice[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListLastPrice[changeCount]]!
                        changeCount = changeCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListLastPrice[changePercent]]!
                        changePercent = changePercent + 1
                    }
                }else if sortByTag == 3{
                    
                    
                    var dicForSymbol = [String : String]()
                    var dicForLastPrice = [String : String]()
                    var dicForChangePercent = [String : String]()
                    var length = 0
                    var lengthForLastPrice = 0
                    var lengthForChangePercent = 0
                    for item in favListSymbol{
                        dicForSymbol[favListChange[length]] = item
                        length = length + 1
                    }
                    for item in favListLastPrice{
                        dicForLastPrice[favListChange[lengthForLastPrice]] = item
                        lengthForLastPrice = lengthForLastPrice + 1
                    }
                    for item in favListChangePercent{
                        dicForChangePercent[favListChange[lengthForChangePercent]] = item
                        lengthForChangePercent = lengthForChangePercent + 1
                    }
                    print(dicForSymbol)
                    print(dicForLastPrice)
                    print(dicForChangePercent)
                    if ascendingOrDescending == true{
                        favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedAscending}} else if ascendingOrDescending == false{
                        favListChange = favListChange.sorted{$0.localizedStandardCompare($1) == .orderedDescending}
                    }
                    print(favListChange)
                    var symbolCount = 0
                    var lastPriceCount = 0
                    var changePercent = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListChange[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListLastPrice{
                        favListLastPrice[lastPriceCount] = dicForLastPrice[favListChange[lastPriceCount]]!
                        lastPriceCount = lastPriceCount + 1
                    }
                    for _ in favListChangePercent{
                        favListChangePercent[changePercent] = dicForChangePercent[favListChange[changePercent]]!
                        changePercent = changePercent + 1
                    }
                    
                }else if sortByTag == 4{
                    
                    var dicForSymbol = [String : String]()
                    var dicForLastPrice = [String : String]()
                    var dicForChange = [String : String]()
                    var length = 0
                    var lengthForLastPrice = 0
                    var lengthForChange = 0
                    for item in favListSymbol{
                        dicForSymbol[favListChangePercent[length]] = item
                        length = length + 1
                    }
                    for item in favListLastPrice{
                        dicForLastPrice[favListChangePercent[lengthForLastPrice]] = item
                        lengthForLastPrice = lengthForLastPrice + 1
                    }
                    for item in favListChange{
                        dicForChange[favListChangePercent[lengthForChange]] = item
                        lengthForChange = lengthForChange + 1
                    }
                    print(dicForSymbol)
                    print(dicForLastPrice)
                    print(dicForChange)
                    if ascendingOrDescending == true { favListChangePercent = favListChangePercent.sorted()}
                    else if ascendingOrDescending == false{
                        favListChangePercent = favListChangePercent.sorted().reversed()
                    }
                    print(favListChangePercent)
                    var symbolCount = 0
                    var lastPriceCount = 0
                    var changeCount = 0
                    for _ in favListSymbol{
                        favListSymbol[symbolCount] = dicForSymbol[favListChangePercent[symbolCount]]!
                        symbolCount = symbolCount + 1
                    }
                    for _ in favListLastPrice{
                        favListLastPrice[lastPriceCount] = dicForLastPrice[favListChangePercent[lastPriceCount]]!
                        lastPriceCount = lastPriceCount + 1
                    }
                    for _ in favListChange{
                        favListChange[changeCount] = dicForChange[favListChangePercent[changeCount]]!
                        changeCount = changeCount + 1
                    }
                    
                }
                
                
                
            }
            print(ascendingOrDescending)
        }
        
        favListTable.reloadData()//the last thing is to reload all the data
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func favListToBeSentFinal(data: [String]) {
        var isAlreadyAdd = false
        var indexes = 0
        for item in favListSymbol{
            if item == data[0]{
               favListSymbol.remove(at: indexes)
               favListLastPrice.remove(at: indexes)
                favListChange.remove(at: indexes)
                favListChangePercent.remove(at: indexes)
                isAlreadyAdd = true
                break
            }
            indexes = indexes + 1
        }
        
        if isAlreadyAdd == false{
        print("This is successfully done on the first screen! I think you are almost done with it!")
        print(data)
        favListSymbol.append(data[0])
        favListLastPrice.append(data[1])
        favListChange.append(data[2])
        favListChangePercent.append(data[3])
        }
            self.favListTable.reloadData()
            print(favListSymbol)
            print(favListChange)
            print(favListChangePercent)
            print(favListLastPrice)
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        acronymTextField.text = favListSymbol[indexPath.row]
        print(favListSymbol[indexPath.row])
        if acronymTextField.text != ""{
            performSegue(withIdentifier: "goToSecondScreen", sender: self)}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favListSymbol.count//the number of rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favList", for: indexPath) as! favListCell
        cell.symbol.text = favListSymbol[indexPath.row]
        cell.lastPrice.text = "$\(favListLastPrice[indexPath.row])"
        cell.changeAndPercent.text = "\(favListChange[indexPath.row]) (\(favListChangePercent[indexPath.row])%)"
        return cell//what to do with it???
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            favListSymbol.remove(at: indexPath.row)
            favListLastPrice.remove(at: indexPath.row)
            favListChange.remove(at: indexPath.row)
            favListChangePercent.remove(at: indexPath.row)
            self.favListTable.reloadData()
           
        }
    }
    
}
