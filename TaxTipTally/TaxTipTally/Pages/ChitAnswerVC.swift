//
//  ChitAnswerVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class ChitAnswerVC: UIViewController {

    @IBOutlet weak var lblNetAmountPayable: UILabel!
    @IBOutlet weak var lblPayableAmountPerPerson: UILabel!
    @IBOutlet weak var lblDividedPerMember: UILabel!
    @IBOutlet weak var lblTotalDivided: UILabel!
    @IBOutlet weak var lblAgentCommission: UILabel!
    @IBOutlet weak var lblAuctionAmount: UILabel!
    @IBOutlet weak var lblChitAmount: UILabel!
    
    var netAmountPayable: Double?
    var payableAmountPerPerson: Double?
    var dividedPerMember: Double?
    var totalDivided: Double?
    var agentCommission: Double?
    var auctionAmount: Double?
    var chitAmount: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNetAmountPayable.text = String(format: "%.2f", netAmountPayable ?? 0)
        lblPayableAmountPerPerson.text = String(format: "%.2f", payableAmountPerPerson ?? 0)
        lblDividedPerMember.text = String(format: "%.2f", dividedPerMember ?? 0)
        lblTotalDivided.text = String(format: "%.2f", totalDivided ?? 0)
        lblAgentCommission.text = String(format: "%.2f", agentCommission ?? 0)
        lblAuctionAmount.text = String(format: "%.2f", auctionAmount ?? 0)
        lblChitAmount.text = String(format: "%.2f", chitAmount ?? 0)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
