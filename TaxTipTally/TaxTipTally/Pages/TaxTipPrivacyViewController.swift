//
//  TaxTipPrivacyViewController.swift
//  TaxTipTally
//
//  Created by TaxTipTally on 2024/11/20.
//
@preconcurrency import WebKit
import UIKit

class TaxTipPrivacyViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var taxTipIndicator: UIActivityIndicatorView!
    @IBOutlet weak var taxTipWebView: WKWebView!
    @IBOutlet weak var taxTipBackBtn: UIButton!
    @IBOutlet weak var taxTipTopCos: NSLayoutConstraint!
    @IBOutlet weak var taxTipBottomCos: NSLayoutConstraint!
    var backAction: (() -> Void)?
    var confData: [Any]?
    @objc var url: String?
    
    func generateRandomColor() {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        print("Generated random color: \(randomColor)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.confData = UserDefaults.standard.array(forKey: UIViewController.getRnergyUserDefaultKey())
        generateRandomColor()
        taxTipInitSubViews()
        taxTipInitConfigNav()
        taxTipInitWebView()
        taxTipStartLoadWebView()
    }
    
    @IBAction func backC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let confData = confData, confData.count > 4 {
            let top = (confData[3] as? Int) ?? 0
            let bottom = (confData[4] as? Int) ?? 0
            
            if top > 0 {
                taxTipTopCos.constant = view.safeAreaInsets.top
            }
            if bottom > 0 {
                taxTipBottomCos.constant = view.safeAreaInsets.bottom
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    @objc func backClick() {
        backAction?()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - INIT
    private func taxTipInitSubViews() {
        taxTipWebView.scrollView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .black
        taxTipWebView.backgroundColor = .black
        taxTipWebView.isOpaque = false
        taxTipWebView.scrollView.backgroundColor = .black
        taxTipIndicator.hidesWhenStopped = true
    }
    
    private func taxTipInitConfigNav() {
        taxTipBackBtn.isHidden = navigationController == nil
        
        guard let url = url, !url.isEmpty else {
            taxTipWebView.scrollView.contentInsetAdjustmentBehavior = .automatic
            return
        }
        
        taxTipBackBtn.isHidden = true
        navigationController?.navigationBar.tintColor = .systemBlue
        
        let image = UIImage(systemName: "xmark")
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backClick))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
    
    private func taxTipInitWebView() {
        guard let confData = confData, confData.count > 7 else { return }
        
        let userContentC = taxTipWebView.configuration.userContentController
        
        if let ty = confData[18] as? Int, ty == 1 {
            if let trackStr = confData[5] as? String {
                let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                userContentC.addUserScript(trackScript)
            }
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let bundleId = Bundle.main.bundleIdentifier,
               let wgName = confData[7] as? String {
                let inPPStr = "window.\(wgName) = {name: '\(bundleId)', version: '\(version)'}"
                let inPPScript = WKUserScript(source: inPPStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                userContentC.addUserScript(inPPScript)
            }
            
            if let messageHandlerName = confData[6] as? String {
                userContentC.add(self, name: messageHandlerName)
            }
        } else {
            userContentC.add(self, name: confData[19] as? String ?? "")
        }
        
        taxTipWebView.navigationDelegate = self
        taxTipWebView.uiDelegate = self
    }
    
    func execute(after delay: TimeInterval, completion: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
        }
    private func taxTipStartLoadWebView() {
        let urlStr = url ?? "https://www.termsfeed.com/live/77dbd1bb-444c-4a4c-a611-827df5b1a53a"
        guard let url = URL(string: urlStr) else { return }
        
        taxTipIndicator.startAnimating()
        let request = URLRequest(url: url)
        taxTipWebView.load(request)
    }
    
    private func taxTipReloadWebViewData(_ adurl: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let storyboard = self.storyboard,
               let adView = storyboard.instantiateViewController(withIdentifier: "TaxTipPrivacyViewController") as? TaxTipPrivacyViewController {
                adView.url = adurl
                adView.backAction = { [weak self] in
                    let close = "window.closeGame();"
                    self?.taxTipWebView.evaluateJavaScript(close, completionHandler: nil)
                }
                let nav = UINavigationController(rootViewController: adView)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let confData = confData, confData.count > 9 else { return }
        
        let name = message.name
        if name == (confData[6] as? String),
           let trackMessage = message.body as? [String: Any] {
            let tName = trackMessage["name"] as? String ?? ""
            let tData = trackMessage["data"] as? String ?? ""
            if let data = tData.data(using: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if tName != (confData[8] as? String) {
                            taxTipSendEvent(tName, values: jsonObject)
                            return
                        }
                        if tName == (confData[9] as? String) {
                            return
                        }
                        if let adId = jsonObject["url"] as? String, !adId.isEmpty {
                            taxTipReloadWebViewData(adId)
                        }
                    }
                } catch {
                    taxTipSendEvent(tName, values: [tName: data])
                }
            } else {
                taxTipSendEvent(tName, values: [tName: tData])
            }
        } else if name == (confData[19] as? String) {
            if let messageBody = message.body as? String,
               let dic = energyJsonToDic(withJsonString: messageBody) as? [String: Any],
               let evName = dic["funcName"] as? String,
               let evParams = dic["params"] as? String {
                
                if evName == (confData[20] as? String) {
                    if let uDic = energyJsonToDic(withJsonString: evParams) as? [String: Any],
                       let urlStr = uDic["url"] as? String,
                       let url = URL(string: urlStr),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else if evName == (confData[21] as? String) {
                    taxTipSendEvents(withParams: evParams)
                }
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.taxTipIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.taxTipIndicator.stopAnimating()
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        if authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
    }

}
