//
//  DisplayEngine.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

/**
 * The class keeps track of objects to display and has the ability of projecting
 * them onto the camera feed image.
 */
class DisplayEngine {
    var objects = [GameObject]()

    func addObject(obj: GameObject) {
        objects.append(obj)
    }
    
    func overlayGameObjects(cameraFrame: CIImage, playerPosition: GlobalPosition) -> CIImage {
        var currentFrame = cameraFrame
        currentFrame = currentFrame.imageByCroppingToRect(UIScreen.mainScreen().bounds)
        for object in objects {
            if (object.isObjectInvisible(playerPosition)) {
                continue;
            }

            let cornerLocations = object.getCornersLocations(playerPosition)
            let transformedImg = object.objectImage.imageByApplyingFilter("CIPerspectiveTransform", withInputParameters: ["inputImage": object.objectImage, "inputTopLeft": cornerLocations[0], "inputTopRight": cornerLocations[1], "inputBottomRight": cornerLocations[3], "inputBottomLeft": cornerLocations[2]]).imageByCroppingToRect(currentFrame.extent)
            let blendFilter = CIFilter(name: "CISourceAtopCompositing", withInputParameters: ["inputImage": transformedImg, "inputBackgroundImage": currentFrame])!
            currentFrame = blendFilter.outputImage!
        }
        return currentFrame
    }
}
