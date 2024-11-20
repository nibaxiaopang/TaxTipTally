//
//  WelcomeVC.swift
//  TaxTipTally
//
//  Created by jin fu on 2024/11/20.
//

import UIKit
import StoreKit

class TaxTipWelcomePage: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        setNotificationPermission()
    }
    
    // MARK: - Functions
    
    func setNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: authOptions) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("User declined notification permissions: \(error?.localizedDescription ?? "No error information")")
                }
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @IBAction func Rate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func Share(_ sender: Any) {
        let objectsToShare = ["TaxTipTally"]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 200, width: 300, height: 300)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func Start(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! TaxTipHomePage
        self.navigationController?.pushViewController(vc, animated: true)
    }
  

}
