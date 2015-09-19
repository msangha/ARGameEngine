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
    
    private static let DEFAULT_UPDATE_RATE = 0.01
    private static let GRAVITY_ACCELERATION = -9.81
    
    private var previousTime: NSTimeInterval?
    
    private var xVelocity: Double = 0.0
    private var yVelocity: Double = 0.0
    private var zVelocity: Double = 0.0
    
    private var xPosition: Double = 0.0
    private var yPosition: Double = 0.0
    private var zPosition: Double = 0.0
    
    private static let K_FILTER_CONSTANT = 0.1
    private var rollingXacc: Double = 0.0
    private var rollingYacc: Double = 0.0
    private var rollingZacc: Double = 0.0
    
    private var roll: Double = 0.0
    private var pitch: Double = 0.0
    private var yaw: Double = 0.0
    
    func startTracking(updateRate: NSTimeInterval = PoseTracker.DEFAULT_UPDATE_RATE) {
        motionManager.deviceMotionUpdateInterval = updateRate
        previousTime = NSDate.timeIntervalSinceReferenceDate()
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
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let interval = currentTime - previousTime!
        //println("\(interval)")
        previousTime = currentTime
        
        // rolling mean values (low pass filter)
        rollingXacc = motionData.userAcceleration.x * PoseTracker.K_FILTER_CONSTANT + rollingXacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        rollingYacc = motionData.userAcceleration.y * PoseTracker.K_FILTER_CONSTANT + rollingYacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        rollingZacc = motionData.userAcceleration.z * PoseTracker.K_FILTER_CONSTANT + rollingZacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        
        // subtract low-pass values to create high pass filter
        let accX = motionData.userAcceleration.x - rollingXacc
        let accY = motionData.userAcceleration.y - rollingYacc
        let accZ = motionData.userAcceleration.z - rollingZacc
        
        xVelocity += accX * interval * PoseTracker.GRAVITY_ACCELERATION
        yVelocity += accY * interval * PoseTracker.GRAVITY_ACCELERATION
        zVelocity += accZ * interval * PoseTracker.GRAVITY_ACCELERATION
        
        xPosition += xVelocity * interval
        yPosition += yVelocity * interval
        zPosition += zVelocity * interval
        
        pitch = motionData.attitude.pitch
        roll = motionData.attitude.roll
        yaw = motionData.attitude.yaw
        
        var v = Point3D(x: 0, y: 1, z: 0)
        var u = Point3D(x: 1, y: 0, z: 0)
        v = v.rotate(pitch, roll: roll, yaw: yaw)
        u = u.rotate(pitch, roll: roll, yaw: yaw)
        
        println("v: " + v.toString())
        println("u: " + u.toString())
        
        //println("\(pitch), \(roll), \(yaw)")
        
        //println("\(xPosition), \(yPosition), \(zPosition)")
        //println("\(xVelocity), \(yVelocity), \(zVelocity)")
        //println("\(accX), \(accY), \(accZ)")
        /*if (accX > 0.2) {
            print("x+ ")
        }
        if (accX < -0.2) {
            print("x- ")
        }
        if (accY > 0.2) {
            print("y+ ")
        }
        if (accY < -0.2) {
            print("y- ")
        }
        if (accZ > 0.2) {
            println("z+")
        }
        if (accZ < -0.2) {
            println("z-")
        }*/
    }
    
}
