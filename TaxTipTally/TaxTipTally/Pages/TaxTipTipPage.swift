//
//  TipVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class TaxTipTipPage: UIViewController {

    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var txtNumberOfPerson: UITextField!
    @IBOutlet weak var txtTip: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Optional: Hide navigation bar
        navigationController?.navigationBar.isHidden = true
        lblAnswer.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        // Perform back action, e.g., dismissing the current view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        // Reset all text fields and label
        txtNumberOfPerson.text = ""
        txtTip.text = ""
        txtAmount.text = ""
        lblAnswer.text = ""
        lblAnswer.isHidden = true
    }
    
    @IBAction func Calculate(_ sender: Any) {
        // Fetch user inputs
        guard let amountText = txtAmount.text, let amount = Double(amountText),
              let tipText = txtTip.text, let tipPercentage = Double(tipText),
              let numberOfPeopleText = txtNumberOfPerson.text, let numberOfPeople = Double(numberOfPeopleText) else {
            // Handle invalid input
            lblAnswer.text = "Please enter valid values."
            return
        }
        
        // Calculate total tip amount
        let tipAmount = amount * (tipPercentage / 100.0)
        let totalAmount = amount + tipAmount
        
        // Calculate amount per person
        let amountPerPerson = totalAmount / numberOfPeople
        
        // Update the label with the result
        lblAnswer.text = String(format: "Tip Amount per Person: $%.2f", amountPerPerson)
        lblAnswer.isHidden = false
    }
}
