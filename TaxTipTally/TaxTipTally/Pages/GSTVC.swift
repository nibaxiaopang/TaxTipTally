//
//  GSTVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class GSTVC: UIViewController {

    @IBOutlet weak var viewPostGst: UIView!
    @IBOutlet weak var viewGst: UIView!
    @IBOutlet weak var btnExeclusive: UIButton!
    @IBOutlet weak var btnInclusive: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtGST: UITextField!
    @IBOutlet weak var btnCalculate: UIButton!
    @IBOutlet weak var lblPostGSTAmount: UILabel!
    @IBOutlet weak var lblTotalGSTAmount: UILabel!
    
    var isInclusiveSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Set default selection
        btnInclusive.setImage(UIImage.init(named: "check"), for: .normal)
        btnExeclusive.setImage(UIImage.init(named: "uncheck"), for: .normal)
        isInclusiveSelected = true
        viewGst.isHidden = true
        viewPostGst.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapGStInclusive(_ sender: Any) {
        if !isInclusiveSelected {
            btnInclusive.setImage(UIImage.init(named: "check"), for: .normal)
            btnExeclusive.setImage(UIImage.init(named: "uncheck"), for: .normal)
            isInclusiveSelected = true
        }
    }
    
    @IBAction func TapGstExeclusive(_ sender: Any) {
        if isInclusiveSelected {
            btnInclusive.setImage(UIImage.init(named: "uncheck"), for: .normal)
            btnExeclusive.setImage(UIImage.init(named: "check"), for: .normal)
            isInclusiveSelected = false
        }
    }
    
    @IBAction func Calculate(_ sender: Any) {
        guard let amountText = txtAmount.text, let amount = Double(amountText),
              let gstText = txtGST.text, let gstRate = Double(gstText) else {
            // Handle invalid input
            lblPostGSTAmount.text = "Invalid input"
            lblTotalGSTAmount.text = ""
            return
        }
        
        let gstAmount: Double
        let postGSTAmount: Double
        
        if isInclusiveSelected {
            // GST inclusive calculation
            gstAmount = amount - (amount / (1 + gstRate / 100))
            postGSTAmount = amount
        } else {
            // GST exclusive calculation
            gstAmount = amount * (gstRate / 100)
            postGSTAmount = amount + gstAmount
        }
        
        lblTotalGSTAmount.text = String(format: "₹%.2f", gstAmount)
        lblPostGSTAmount.text = String(format: "₹%.2f", postGSTAmount)
        viewGst.isHidden = false
        viewPostGst.isHidden = false
    }
    
    @IBAction func Reset(_ sender: Any) {
        txtAmount.text = ""
        txtGST.text = ""
        lblPostGSTAmount.text = ""
        lblTotalGSTAmount.text = ""
        // Reset selection
        btnInclusive.setImage(UIImage.init(named: "check"), for: .normal)
        btnExeclusive.setImage(UIImage.init(named: "uncheck"), for: .normal)
        isInclusiveSelected = true
        viewGst.isHidden = true
        viewPostGst.isHidden = true
    }
}
