//
//  ViewController.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let displayEngine = DisplayEngine()
        let pikachuObject = GameObject(imagePath: "pikachu.gif", playerLocation: GlobalPosition(p: Point3D(), o: Orientation(u: Point3D(x: 1.0, y: 0.0, z: 0.0), v: Point3D(x: 0.0, y: 0.0, z: 1.0), w: Point3D(x: 0.0, y: 1.0, z: 0.0))))
        displayEngine.addObject(pikachuObject)
        let alfa = 5*M_PI/100.0
        let currentLocation = GlobalPosition(p: Point3D(), o: Orientation(u: Point3D(x: cos(alfa), y: sin(alfa), z: 0.0), v: Point3D(x: 0.0, y: 0.0, z: 1.0), w: Point3D(x: cos(alfa+M_PI/2.0), y: sin(alfa+M_PI/2.0), z: 0.0)))
        let background = CIImage(image: getImageWithColor(UIColor.blackColor(), size: UIScreen.mainScreen().bounds.size))!.imageByCroppingToRect(UIScreen.mainScreen().bounds)
        
        let img = UIImage(CIImage: displayEngine.overlayGameObjects(background, playerPosition: currentLocation))
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height)
        self.view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

