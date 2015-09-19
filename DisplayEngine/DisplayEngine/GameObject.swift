//
//  GameObject.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation
import CoreImage

// Class to store game objects that will be displayed on the camera video feed.
// The display engine is going to call a method here that returns the view of
// the object that the camera should get. After that the engine overlays the
// result on top of camera feed.
class GameObject {
  let SCREEN_LENGTH = 0.158
  let SCREEN_WIDTH = 0.0778
  let SCREEN_DISTANCE = 0.1
  let INITIAL_OBJECT_DISTANCE = 3.0
  let OBJECT_WIDTH = 0.5
  let OBJECT_HEIGHT = 0.5

  var objectImage = CIImage()
  var playerStartPosition = Point3D()
  var objectCornerPositions = [Point3D()];
  let screenFocalCornerPositions = [Point3D()]
  
  init(imagePath: String, playerLocation: GlobalPosition) {
    // Initialize the object image.
    let imageURL = NSBundle.mainBundle().URLForResource(imagePath, withExtension: "png")!
    objectImage = CIImage(contentsOfURL: imageURL)!
    // Initialize the player start position.
    playerStartPosition = playerLocation.p
    // Calculate and init corner positions.
    let distantScreenCenter = playerLocation.p.add(playerLocation.o.w.mul(INITIAL_OBJECT_DISTANCE))
    let topLeftCorner = distantScreenCenter.add(
        playerLocation.o.u.mul(
          -sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: 0.5 * OBJECT_WIDTH)))
      .add(
        playerLocation.o.v.mul(
          sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: OBJECT_HEIGHT/2.0)))
    objectCornerPositions.append(topLeftCorner)
    let topRightCorner = distantScreenCenter.add(
        playerLocation.o.u.mul(
          sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: 0.5 * OBJECT_WIDTH)))
      .add(
        playerLocation.o.v.mul(
          sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: OBJECT_HEIGHT/2.0)))
    objectCornerPositions.append(topRightCorner)
    let bottomLeftCorner = distantScreenCenter.add(
        playerLocation.o.u.mul(
          -sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: 0.5 * OBJECT_WIDTH)))
      .add(
        playerLocation.o.v.mul(
          -sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: OBJECT_HEIGHT/2.0)))
    objectCornerPositions.append(bottomLeftCorner)
    let bottomRightCorner = distantScreenCenter.add(
        playerLocation.o.u.mul(
          sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: 0.5 * OBJECT_WIDTH)))
      .add(
        playerLocation.o.v.mul(
          -sizeAtDistance(INITIAL_OBJECT_DISTANCE, focalSize: OBJECT_HEIGHT/2.0)))
    objectCornerPositions.append(bottomRightCorner)
  }

  func getCornersLocations(playerPosition: GlobalPosition) {
    var cornerLocations = [CIVector];
    for corner in cornerLocations {
      
    }
  }
  
  // Given distance to the object from the camera and it's size when it's at a focal distance.
  // @param distance distance from the camera to the object
  // @param focalSize size when the object it as focal distance
  // @return the size as observed from distance 'distance'
  func sizeAtDistance(distance: Double, focalSize: Double) -> Double {
    return focalSize / distance;
  }

  // Given distance to the object and the observed size.
  // @param distance distance from the camera to the object
  // @param nonFocalSize the observed distance
  // @return the size as would be observed from focal distane
  func sizeAtFocal(distance: Double, nonFocalSize: Double) -> Double {
    return nonFocalSize * distance
  }
}