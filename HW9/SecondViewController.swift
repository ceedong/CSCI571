//
//  SecondViewController.swift
//  
//
//  Created by Mark Dong on 11/14/17.
//

import UIKit
import SwiftSpinner


protocol goToTheFirstScreenFinal {
    func favListToBeSentFinal(data: [String])
}

class SecondViewController: UIViewController, toTheFirstScreen{
    var delegate : goToTheFirstScreenFinal?
    var textPassedOver : String?
    var symbolPassedOver : [String]?
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBAction func togglePart(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
           // label.text = "Current"
           UIView.animate(withDuration: 0.5, animations: {
            self.firstView.alpha = 0.0//for the news
            self.secondView.alpha = 0.0//for the historical
            self.thirdView.alpha = 1.0//for the current
           })
        } else if sender.selectedSegmentIndex == 1{
            
           // label.text = "Historical"
            UIView.animate(withDuration: 0.5, animations: {
                self.firstView.alpha = 0.0
                self.secondView.alpha = 1.0
                self.thirdView.alpha = 0.0
            })
            
        } else if sender.selectedSegmentIndex == 2{
            
           // label.text = "News"
            UIView.animate(withDuration: 0.5, animations: {
                self.firstView.alpha = 1.0
                self.secondView.alpha = 0.0
                self.thirdView.alpha = 0.0
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchText = textPassedOver
        let splitText = searchText?.components(separatedBy: " -")
        // print(splitText?[0] ?? "null")
        label.text = splitText?[0]
        label.alpha = 0.0
        self.navigationItem.title = splitText?[0]
        // Do any additional setup after loading the view.
       // performSegue(withIdentifier: "goToTableDisplay", sender: self)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTableDisplay"{
        let secondVC = segue.destination as! TableViewController
            secondVC.symbolPassedOver = textPassedOver!
            secondVC.favListSymbol = symbolPassedOver!
            secondVC.delegate = self
        } else if segue.identifier == "goToHistoricalDisplay"{
        let thirdVC = segue.destination as! HistoricalViewController
            thirdVC.symbolPassedOver = textPassedOver!
        } else if segue.identifier == "goToNewsDisplay"{
        let fourthVC = segue.destination as! NewsViewController
            fourthVC.symbolPassedOver = textPassedOver!
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

    func favListPassed(data: [String]) {
        let stringList = data
        print("This is succcessfully done!")
        print(stringList)
        delegate?.favListToBeSentFinal(data: stringList)
    }
    
}
