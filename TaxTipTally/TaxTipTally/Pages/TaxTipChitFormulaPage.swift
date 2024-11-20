//
//  ChitFormulaVC.swift
//  TaxTipTally
//
//  Created by TaxTipTally on 2024/11/20.
//

import UIKit

class TaxTipChitFormulaPage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnFormula(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChitsVC") as! TaxTipChitsPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
