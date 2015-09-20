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

    @IBOutlet weak var pokeBeacon: UIImageView!
    @IBAction func cameraButton(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Menu.target = self.revealViewController()
        
        Menu.action =  Selector("revealToggle:")
        
        var pokeXPosition = pokeBeacon.frame.origin.x
        var pokeYPosition = pokeBeacon.frame.origin.y
        print(pokeXPosition)
        print(pokeYPosition)
        
        let origin = CGPointMake(190,480)
        
        let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:70, position:origin)
        view.layer.insertSublayer(pulseEffect, below: pokeBeacon.layer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

