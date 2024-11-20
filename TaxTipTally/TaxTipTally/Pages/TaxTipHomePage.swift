//
//  HomeVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit

class TaxTipHomePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Discount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscountFormulaVC") as! TaxTipDiscountFormulaPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Chits(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChitFormulaVC") as! TaxTipChitFormulaPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func GST(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GSTFormulaVC") as! TaxTipGSTFormulaPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Tips(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TipFormulaVC") as! TaxTipFormulaPage
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
