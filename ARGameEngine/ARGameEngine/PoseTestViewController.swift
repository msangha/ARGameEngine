//
//  ViewController.swift
//  ARGameEngine
//
//  Created by Manjot Sangha on 2015-09-19.
//  Copyright (c) 2015 Manjot Sangha. All rights reserved.
//

import UIKit

class PoseTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PoseTracker.sharedInstance.startTracking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

