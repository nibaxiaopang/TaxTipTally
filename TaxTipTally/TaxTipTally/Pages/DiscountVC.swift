//
//  DiscountVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class DiscountVC: UIViewController {

    @IBOutlet weak var viewFinal: UIView!
    @IBOutlet weak var viewSaving: UIView!
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var lblTotalSavingsAmount: UILabel!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSaving.isHidden = true
        viewFinal.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func Reset(_ sender: Any) {
        txtAmount.text = ""
        txtDiscount.text = ""
        viewSaving.isHidden = true
        viewFinal.isHidden = true
    }
    
    @IBAction func Calculate(_ sender: Any) {
        guard let amountText = txtAmount.text, !amountText.isEmpty,
              let discountText = txtDiscount.text, !discountText.isEmpty,
              let amount = Double(amountText),
              let discount = Double(discountText) else {
            showAlert(message: "Please enter valid numbers for amount and discount.")
            return
        }
        
        if discount < 0 || discount > 100 {
            showAlert(message: "Please enter a discount percentage between 0 and 100.")
            return
        }
        
        let savings = amount * (discount / 100)
        let finalAmount = amount - savings
        
        lblTotalSavingsAmount.text = String(format: "%.2f", savings)
        lblFinalAmount.text = String(format: "%.2f", finalAmount)
        
        viewSaving.isHidden = false
        viewFinal.isHidden = false
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "TaxTipTally", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
