//
//  ViewController.swift
//  TestSDK
//
//  Created by Atmaram on 10/10/19.
//  Copyright © 2019 Atmaram. All rights reserved.
//

import UIKit
import ManchSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after  loading the view.
        
//        let manch = ManchSDKManager()
        let fName = "Atmaram"
           let lName = "Thakur"
           let templateKey = "TMPTS00357"
           let docType = "mono external"
           let orgKey = "TST00019"
           let securityKey = "cPaQHY4RS1Sncoxr"
           let docUrl = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
//           let preAuthType = "N"
           let environment = "DEV"
//           var eSignMethod = "OTP" //EMAIL_OTP, OTP, MOBILE_OTP
        let timeInMiliSecDate = Date()
               let reqId =  "\(timeInMiliSecDate.timeIntervalSince1970 * 1000000 )"
        
        let authToken = AuthTokenGenerator().generate(orgKey: orgKey, reqId: reqId , securityKey: securityKey)
        
//        let params = ["firstName" : fName,
//                      "lastName": lName,
//                      "templateKey": templateKey,
//                      "documentType": docType,
//                      "environment":environment,
//                      "requestId": reqId,
//                      "authenticationToken": authToken,
//                      "acceptTransaction": "Y",
//                      "documentURL" : "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
//                      "orgKey": orgKey,
//                      "securityKey": securityKey
//
//        ]
        let sdkManager = ManchSDKManager()
//        sdkManager.createTransaction(param: params, viewController: self, completionHandler:{ (status, resp) -> Void in
        

//            if status{
//                print("DocUrl = \(resp)")
        
                let params = ["requestId": reqId,
                              "documentURL" : "resp",
                              "environment" :"DEV",
                              "acceptTransaction" : "Y",
                              "authenticationToken" : authToken
                ]
                sdkManager.eSignDocument(param: params, completion: {(status, response) in
                    print("Status=\(status) and response = \(response)")
                    
//                    if status{
//                        sdkManager.sendStatusRequest()
//                    }
                })
//            }else{
//                // error case
//            }
//            })
    }
    


}

