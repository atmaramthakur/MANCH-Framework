//
//  ManchSDKManager.swift
//  ManchSDK
//
//  Created by Atmaram on 10/10/19.
//  Copyright © 2019 Atmaram. All rights reserved.
//

import Foundation

public class ManchSDKManager{
    
    public init() {}
    var networkManager: NetworkManager!
    
    var transactionUrl = "";
    
    let fName = "Atmaram"
    let lName = "Thakur"
    let templateKey = "TMPTS00357"
    let docType = "mono external"
    let orgKey = "TST00019"
    let securityKey = "cPaQHY4RS1Sncoxr"
    let docUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    let preAuthType = "N"
    let environment = "DEV"
    var eSignMethod = "OTP" //EMAIL_OTP, OTP, MOBILE_OTP
    
    public func printMe(str: String){
        print("Printing \(str)")
    }
    
    func sendCreateRequest(){
        let timeInMiliSecDate = Date()
        let reqId =  "\(timeInMiliSecDate.timeIntervalSince1970 * 1000000 )"
        networkManager = NetworkManager(reqId: reqId, orgKey: orgKey, securityKey: securityKey)
        let documentReq = DocumentReq.init(documentType: docType, documentStorageId: nil, documentBytes: nil, documentTypeUrl: docUrl)
        
        
        let request = CreateTransactionReq.init(templateKey: templateKey, firstName: fName, lastName: lName, esignMethod: eSignMethod, mobileNumber: "9902646646", email: "atmaram.thakur@gmail.com", preAuth: preAuthType, documents: [documentReq], callbackURL: "http://dev.manchtech.com:3000/sample-server/esign/callback")
        networkManager.createTransaction(req: request) { resp, error in
            //            print("error = \(error) and resp=\(resp)")
            if error != nil {
                // error case
            }else{
                if let createTxnResponse = resp as? CreateTransactionResponse{
                    // handle the response
                    if(createTxnResponse.responseCode == "1"){
                        if let txnUrl = createTxnResponse.data?.transaction?.transactionLink{
                            self.transactionUrl = txnUrl
                            print("transactionUrl : \(txnUrl)")
                        }
                        if let doc = createTxnResponse.data?.documents?[0], let docurl = doc.documentLink{
                            // post this url for signing to the webview:
                            //                            let url = URL(string: docurl+"/sign-url")!
                            //                            self.webView.load(URLRequest(url: url))
                            self.networkManager.getESignUrl(req: docurl) { resp, error in
                                //                                print("error = \(error) and resp=\(resp)")
                                if error != nil {
                                    
                                }else{
                                    //                                    print()
                                    if let esignResponse = resp as? geteSignResponse{
                                        if let signUrl = esignResponse.data?.signURL{
                                            DispatchQueue.main.async {
                                                //let url = URL(string: signUrl)!
                                                //self.webView.load(URLRequest(url: url))
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        //                    if(self.preAuthType == "Y"){
                        //                        // you can directly call Sign Doc
                        //                        DispatchQueue.main.async {
                        //                            //Do UI Code here.
                        //                            self.sendSignDocRequest()
                        //                        }
                        //
                        //                    }else{
                        //                        // call the next api
                        //                        if (self.eSignMethod == "OTP") {
                        //                            self.sendRequestXML();
                        //                        }else{
                        //                           // display UI for Entering OTP received via email / mobile number
                        //                             self.sendOTPRequest();
                        //                        }
                        //                    }
                    }else{
                        // invalid response
                        print("Invalid response")
                    }
                }else{
                    // invalid response
                    print("Invalid response")
                }
                //            print("resp= \(resp)")
                //            print("error =\(error)")
            }
        }
    }
}
