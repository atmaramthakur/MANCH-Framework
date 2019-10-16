//
//  ManchViewController.swift
//  ManchSDK
//
//  Created by Atmaram on 10/10/19.
//  Copyright © 2019 Atmaram. All rights reserved.
//

import UIKit
import WebKit

class  ManchViewController: UIViewController ,WKNavigationDelegate {
    
    
    var webView: WKWebView!
    
    @IBOutlet weak var otpField: UITextField!
   
    
    var transactionUrl = "";
    
    
    override func loadView() {
        webView = WKWebView()
        
        webView.navigationDelegate = self
        view = webView
    }
    @IBAction func onClick(_ sender: Any) {
        if(!otpField.text!.isEmpty){
            //            SignDocRequest()
        }
    }
    //    init(networkManager: NetworkManager) {
    //        super.init(nibName: nil, bundle: nil)
    //        self.networkManager = networkManager
    //    }
    
    
    //    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    //        let trust = challenge.protectionSpace.serverTrust!
    //        let exceptions = SecTrustCopyExceptions(trust)
    //        SecTrustSetExceptions(trust, exceptions)
    //        completionHandler(.useCredential, URLCredential(trust: trust))
    //    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.absoluteString {
            print("host :: "+host)
            //            print("url :"+(navigationAction.request.url?.absoluteString ?? "value"))
            if host.starts(with:"https://dev.manchtech.com/nsdl-esp/authenticate/esignCancel"){
                print("User Cancelled")
            }
            else if host.starts(with:"https://dev.manchtech.com/redirect/webview-post-esign.html?"){
                print("write your own logic")
                
                print("transactionUrl \(transactionUrl)")
                sendStatusRequest(docurl: transactionUrl);
                
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = .green
       
        
    }
    
    func sendSignDocRequest() {
        let request = SignDocRequest.init(otp: otpField.text ?? "", preAuth: preAuthType)
        networkManager.signDocRequest(req: request) { resp, error in
            if error != nil {
                // error case
            }else{
                if let signResponse = resp as? ManchResponse{
                    // handle the response
                    if(signResponse.responseCode == "1"){
                        //                        self.sendStatusRequest()
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func sendRequestXML(){
        //        let request = SignDocRequest.init(otp: "123456", preAuth: preAuthType)
        networkManager.sendRrequestXML() { resp, error in
            if error != nil {
                // error case
            }else{
                if let response = resp as? ESignRes{
                    if (self.eSignMethod == "OTP") {
                        // open NSDL page
                        DispatchQueue.main.async {
                            //                        self.openNSDLApp(msg: response.data.requestXML)
                        }
                    }else{
                        // show OTP fields in screen
                    }
                }
                
            }
        }
    }
    
    func getSignedDocument(url: String){
        networkManager.getSignDoc(url: url) { resp, error in
            if error != nil {
                // error case
            }else{
                do{
                    if let filename = resp as? URL{
                        let req = NSURLRequest(url: filename)
                        self.webView.load(req as URLRequest)
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    func displayDialog(url: String){
        let alert = UIAlertController(title: "Alert", message: url, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Open", style: UIAlertAction.Style.default, handler: {action in
            self.getSignedDocument(url: url)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendStatusRequest(docurl: String){
        self.networkManager.getTxnStatus(url: docurl) { resp, error in
            print("error = \(error) and resp=\(resp)")
            if error != nil {
                
            }else{
                if let response = resp as? StatusResponse{
                    if let docs = response.data?.documents{
                        // open NSDL page
                        if(docs.count > 0){
                            if let url = docs[0].documentURL{
                                self.displayDialog(url: url)
                            }
                            
                        }else{
                            // nothing
                        }
                        DispatchQueue.main.async {
                            
                        }
                    }else{
                        // show OTP fields in screen
                    }
                }
            }
        }
    }
    
    //    func sendOTPRequest(){
    //        //        let request = SignDocRequest.init(otp: "123456", preAuth: preAuthType)
    //        networkManager.sendOTP() { resp, error in
    //            if error != nil {
    //                // error case
    //            }else{
    //                if let response = resp as? TransactionStatusRes{
    //
    //                }
    //
    //            }
    //        }
    //    }
    
    
    func openNSDLApp(msg: String)  {
        var returnUrl = "asp:blooms.ManchSDKSample?"
        // Conversion of Request xml to base64 format
        let data = msg.data(using: .utf8)
        let base64RequestXml = data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        // communicate to NSDL iPA
        var paramToPass = "env=\(environment)&msg=\(base64RequestXml)&returnUrl=\(returnUrl)"
        var nsdlUrl = "capturensdl:com.nsdl.egov.sdkeSignAuthIOSSDK?"
        var nsdlUrlWithParam = "\(nsdlUrl)\(paramToPass)"
        let app = UIApplication.shared
        guard let url = NSURL.init(string: nsdlUrlWithParam)else {return}
        app.open(url as URL)
    }
    
}

