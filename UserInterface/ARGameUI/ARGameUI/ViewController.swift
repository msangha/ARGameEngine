//
//  ViewController.swift
//  ARGameUI
//
//  Created by Tzer Wong on 9/19/15.
//  Copyright © 2015 Tzer Wong. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var Menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Menu.target = self.revealViewController()
        
        Menu.action =  Selector("revealToggle:")
        	


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

