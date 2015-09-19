//
//  GameObject.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation
import CoreImage

class GameObject {
  var objectImage = CIImage()
  var playerStartPosition = Point3D()
  var cornerPositions = [Point3D()];

  func initWithImage(imagePath: String, playerLocation: GlobalPosition) {
    // Initialize the object image.
    let imageURL = NSBundle.mainBundle().URLForResource(imagePath, withExtension: "png")!
    objectImage = CIImage(contentsOfURL: imageURL)!
    // Initialize the player start position.
    playerStartPosition = playerLocation.p
    // Calculate and init corner positions.
    // TODO(aliamir): Actually do this
    let topLeftCorner = Point3D(x: -1.0, y: 2.0, z: 0.0)
    cornerPositions.append(topLeftCorner)
    let topRightCorner = Point3D(x: 1.0, y: 2.0, z: 0.0)
    cornerPositions.append(topRightCorner)
    let bottomLeftCorner = Point3D(x: 1.0, y: 2.0, z: 0.0)
    cornerPositions.append(bottomLeftCorner)
    let bottomRightCorner = Point3D(x: 1.0, y: 2.0, z: 0.0)
    cornerPositions.append(bottomRightCorner)
  }
}