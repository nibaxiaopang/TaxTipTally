//
//  ChitsVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class ChitsVC: UIViewController {

    @IBOutlet weak var txtAuctionMonth: UITextField!
    @IBOutlet weak var txtAuctionAmount: UITextField!
    @IBOutlet weak var txtAgentCommison: UITextField!
    @IBOutlet weak var txtTotalMember: UITextField!
    @IBOutlet weak var txtTotalMonth: UITextField!
    @IBOutlet weak var txtChitValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func Reset(_ sender: Any) {
        txtAuctionMonth.text = ""
        txtAuctionAmount.text = ""
        txtAgentCommison.text = ""
        txtTotalMember.text = ""
        txtTotalMonth.text = ""
        txtChitValue.text = ""
    }
    
    @IBAction func Calculate(_ sender: Any) {
        guard let auctionMonth = txtAuctionMonth.text, let auctionAmount = txtAuctionAmount.text, let agentCommission = txtAgentCommison.text, let totalMember = txtTotalMember.text, let totalMonth = txtTotalMonth.text, let chitValue = txtChitValue.text,
              let auctionMonthValue = Int(auctionMonth), let auctionAmountValue = Double(auctionAmount), let agentCommissionValue = Double(agentCommission), let totalMemberValue = Int(totalMember), let totalMonthValue = Int(totalMonth), let chitValueValue = Double(chitValue) else {
            // Handle invalid input
            let alert = UIAlertController(title: "TaxTipTally", message: "Please enter valid values.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Perform your calculation logic here
        // Example calculations:
        let totalCommission = auctionAmountValue * (agentCommissionValue / 100)
        let netAmountPayable = chitValueValue - auctionAmountValue - totalCommission
        let payableAmountPerPerson = netAmountPayable / Double(totalMemberValue)
        let dividedPerMember = auctionAmountValue / Double(totalMemberValue)
        let totalDivided = dividedPerMember * Double(auctionMonthValue)
        
        // Initialize ChitAnswerVC and pass calculated values
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chitAnswerVC = storyboard.instantiateViewController(withIdentifier: "ChitAnswerVC") as? ChitAnswerVC {
            chitAnswerVC.netAmountPayable = netAmountPayable
            chitAnswerVC.payableAmountPerPerson = payableAmountPerPerson
            chitAnswerVC.dividedPerMember = dividedPerMember
            chitAnswerVC.totalDivided = totalDivided
            chitAnswerVC.agentCommission = totalCommission
            chitAnswerVC.auctionAmount = auctionAmountValue
            chitAnswerVC.chitAmount = chitValueValue
            navigationController?.pushViewController(chitAnswerVC, animated: true)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
