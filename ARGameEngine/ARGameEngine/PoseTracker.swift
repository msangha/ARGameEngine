//
//  PoseTracker.swift
//  ARGameEngine
//
//  Created by Manjot Sangha on 2015-09-19.
//  Copyright (c) 2015 Manjot Sangha. All rights reserved.
//

import Foundation
import CoreMotion

class PoseTracker {
    
    static let sharedInstance: PoseTracker = PoseTracker()
    private let motionManager = CMMotionManager()
    private static let DEFAULT_UPDATE_RATE = 0.1
    
    func startTracking(updateRate: NSTimeInterval = DEFAULT_UPDATE_RATE) {
        motionManager.deviceMotionUpdateInterval = updateRate
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motionData: CMDeviceMotion?, error: NSError?) in
            if (error != nil){
                println(error?.description)
                return
            }
            self.processMotionData(motionData!)
        }
    }
    
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func processMotionData(motionData: CMDeviceMotion) {
        println("\(motionData.userAcceleration.x, motionData.userAcceleration.y, motionData.userAcceleration.z)")
    }
    
}
