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
        ManchSDKManager().printMe(str: "Hello")
    }


}

