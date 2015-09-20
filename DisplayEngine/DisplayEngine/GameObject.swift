//
//  GameObject.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

// Class to store game objects that will be displayed on the camera video feed.
// The display engine is going to call a method here that returns the view of
// the object that the camera should get. After that the engine overlays the
// result on top of camera feed.
class GameObject {
    let PLAYER_HEIGHT = 200.0
    let PHONE_LENGTH = 0.158
    let PHONE_WIDTH = 0.0778
    let PHONE_DISTANCE = 0.11
    let INITIAL_OBJECT_DISTANCE = 2.5
    let OBJECT_WIDTH = 100.0
    let OBJECT_HEIGHT = 100.0
    let EPS = 0.05
    let MAX_DISTANCE = 9.0
    
    var objectImage = CIImage()
    var playerStartPosition = Point3D()
    var objectCornerPositions = [Point3D]()
    
    init(imagePath: String, playerLocation: GlobalPosition) {
        print("\(UIScreen.mainScreen().bounds)")
        
        // Initialize the object image.
        objectImage = CIImage(image: UIImage(named: imagePath)!)!
        
        // Initialize the player start position.
        playerStartPosition = playerLocation.p
        
        print("initially global position: \(playerLocation)")

        // Calculate and init corner positions.
        // Adjust the direction of the camera so that the z-component is removed. we
        // don't want to end up with a GameObject inside a ceiling or floor.
        var wo = playerLocation.o.w
        wo.z = 0.0
        let lengthOfCO = sqrt(wo.x*wo.x + wo.y*wo.y)
        wo.x /= lengthOfCO
        wo.y /= lengthOfCO
        let uo = Point3D(x: wo.y, y: -wo.x, z: 0.0)
        let vo = Point3D(x: 0.0, y: 0.0, z: 1.0)

        print("wo=\(wo) uo=\(uo) vo=\(vo)")

        // Calculate the adjusted screen plane center.
        let distantScreenCenter = playerLocation.p.add(wo.mul(INITIAL_OBJECT_DISTANCE)).sub(vo.mul(PLAYER_HEIGHT-OBJECT_HEIGHT/2.0))
        let topLeftCorner = distantScreenCenter.add(
            uo.mul(
                -0.5 * OBJECT_WIDTH)).add(
            vo.mul(
                0.5 * OBJECT_HEIGHT))
        objectCornerPositions.append(topLeftCorner)
        let topRightCorner = distantScreenCenter.add(
            uo.mul(
                0.5 * OBJECT_WIDTH)).add(
            vo.mul(
                0.5 * OBJECT_HEIGHT))
        objectCornerPositions.append(topRightCorner)
        let bottomLeftCorner = distantScreenCenter.add(
            uo.mul(
                -0.5 * OBJECT_WIDTH)).add(
            vo.mul(
                -0.5 * OBJECT_HEIGHT))
        objectCornerPositions.append(bottomLeftCorner)
        let bottomRightCorner = distantScreenCenter.add(
            uo.mul(
                0.5 * OBJECT_WIDTH)).add(
            vo.mul(
                -0.5 * OBJECT_HEIGHT))
        objectCornerPositions.append(bottomRightCorner)
    }

    func isObjectInvisible(playerPosition: GlobalPosition) -> Bool {
        for corner in objectCornerPositions {
            let distance = corner.sub(playerPosition.p).dot(playerPosition.o.w)
            print("distance=\(distance)")
            if (distance < EPS || distance > MAX_DISTANCE) {
                return true
            }
        }
        return false
    }

    func getCornersLocations(playerPosition: GlobalPosition) -> [CIVector] {
        var cornerLocations = [CIVector]()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        for corner in objectCornerPositions {
            let distance = corner.sub(playerPosition.p).dot(playerPosition.o.w)
            //print("playerPosition.o.w=\(playerPosition.o.w) \(distance)")
            let centerPoint = playerPosition.p.add(playerPosition.o.w.mul(distance))
            let dWidth = corner.sub(centerPoint).dot(playerPosition.o.u)
            let dHeight = corner.sub(centerPoint).dot(playerPosition.o.v)
            //print("distance to object=\(distance) with dw=\(dWidth) dh=\(dHeight)")
            let pixelX = dWidth / distance + (Double)(screenSize.width) / 2.0
            let pixelY = dHeight / distance + (Double)(screenSize.height) / 2.0
            cornerLocations.append(CIVector(x: (CGFloat)(pixelX), y: (CGFloat)(pixelY)))
        }
        print("\(cornerLocations) screenSize=\(screenSize)")
        return cornerLocations
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