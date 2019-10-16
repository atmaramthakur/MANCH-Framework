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
        
        let params = ["firstName" : fName,
                      "lastName": lName,
                      "templateKey": templateKey,
                      "documentType": docType,
                      "environment":environment,
                      "requestId": reqId,
//                      "authenticationToken": "",
                      "acceptTransaction": "Y",
                      "documentURL" : "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                      "orgKey": orgKey,
                      "securityKey": securityKey
                      
        ]
        ManchSDKManager().createTransaction(param: params, viewController: self, completionHandler:{ (status, response) -> Void in
            print("Status : \(status) and url =\(response)")
            })
    }


}

