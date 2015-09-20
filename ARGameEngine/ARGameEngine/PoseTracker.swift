//
//  PoseTracker.swift
//  ARGameEngine
//
//  Created by Manjot Sangha on 2015-09-19.
//  Copyright (c) 2015 Manjot Sangha. All rights reserved.
//

import Foundation
import CoreMotion

class Accumulator {
    let EPS = 0.05
    let MAX_ELEMENTS = 3
    var sum = 0.0
    var measurements = [Double]()
    
    func addValue(x: Double) -> Void {
        //if (abs(x) < EPS) {
        //    measurements.append(0.0)
        //} else {
            measurements.append(x)
            sum += x
        //}

        if (measurements.count > MAX_ELEMENTS) {
            sum -= measurements[0]
            measurements.removeAtIndex(0)
            // measurements.removeFirst()
        }
    }

    func getAverage() -> Double {
        var ret = sum / (Double)(measurements.count)
        if (fabs(ret) < EPS) {
            return 0.0
        }
        return ret
    }
}

class PointAccumulator {
    var x = Accumulator()
    var y = Accumulator()
    var z = Accumulator()
    
    func addValue(val: Point3D) -> Void {
        x.addValue(val.x)
        y.addValue(val.y)
        z.addValue(val.z)
    }
    
    func getAverage() -> Point3D {
        return Point3D(x: x.getAverage(), y: y.getAverage(), z: z.getAverage())
    }
}

public class PoseTracker {
    
    let ACCELERATION_EPS = 0.005
    static let sharedInstance: PoseTracker = PoseTracker()
    private let motionManager = CMMotionManager()
    
    private static let DEFAULT_UPDATE_RATE = 0.2
    private static let GRAVITY_ACCELERATION = -9.81
    private static let K_FILTER_CONSTANT = 0.1
    private static let UNIT_VECTOR_V = Point3D(x: 0, y: 1, z: 0)
    private static let UNIT_VECTOR_U = Point3D(x: 1, y: 0, z: 0)
    
    private var previousTime: NSTimeInterval?

    private var accelerationAverager = PointAccumulator()
    private var velocity = Point3D()
    private var position = Point3D()
    public var globalPosition = GlobalPosition()
    
    private var rollingXacc: Double = 0.0
    private var rollingYacc: Double = 0.0
    private var rollingZacc: Double = 0.0
    
    private var pose: GlobalPosition = GlobalPosition()
    
    func startTracking(updateRate: NSTimeInterval = PoseTracker.DEFAULT_UPDATE_RATE) {
        motionManager.deviceMotionUpdateInterval = updateRate
        previousTime = NSDate.timeIntervalSinceReferenceDate()
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motionData: CMDeviceMotion?, error: NSError?) in
            if (error != nil){
                print(error?.description)
                return
            }
            self.pose = self.processMotionData(motionData!)
        }
    }
    
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func getPose() -> GlobalPosition {
        return pose
    }
    
    private func processMotionData(motionData: CMDeviceMotion) -> GlobalPosition {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let interval = currentTime - previousTime!
        previousTime = currentTime
        
        // find orientation
        let pitch = motionData.attitude.pitch
        let roll = motionData.attitude.roll
        let yaw = motionData.attitude.yaw
        
        let v = PoseTracker.UNIT_VECTOR_V.rotate(pitch, roll: roll, yaw: yaw)
        let u = PoseTracker.UNIT_VECTOR_U.rotate(pitch, roll: roll, yaw: yaw)
        
        assert(v.len() > 1.0-1e-4)
        assert(u.len() > 1.0-1e-4)
        
        let orientation = Orientation(u: u, v: v)
        
        /*// rolling mean values (low pass filter)
        rollingXacc = motionData.userAcceleration.x * PoseTracker.K_FILTER_CONSTANT + rollingXacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        rollingYacc = motionData.userAcceleration.y * PoseTracker.K_FILTER_CONSTANT + rollingYacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        rollingZacc = motionData.userAcceleration.z * PoseTracker.K_FILTER_CONSTANT + rollingZacc*(1 - PoseTracker.K_FILTER_CONSTANT)
        // subtract low-pass values to create high pass filter*/
        
        // find position
        let rawAcceleration = Point3D(x: motionData.userAcceleration.x, y: motionData.userAcceleration.y, z: motionData.userAcceleration.z)
        let accelerationGlobal = rawAcceleration.rotate(pitch, roll: roll, yaw: yaw)
        
        // println(accelerationGlobal.toString())
        
        accelerationAverager.addValue(accelerationGlobal)

        velocity = velocity.add(accelerationAverager.getAverage().mul(interval * PoseTracker.GRAVITY_ACCELERATION))
        if (accelerationAverager.getAverage().len2D() < ACCELERATION_EPS) {
            velocity.x = 0.0
            velocity.y = 0.0
        }
        if (accelerationAverager.getAverage().len() < ACCELERATION_EPS) {
            velocity = Point3D()
        }
        //position = position.add(velocity.mul(interval))
        
        //print(position.toString())
        //print("u=\(u.toString()) v=\(v.toString())")
        //println(position.toString())

        /*
        if (globalPosition.o.u.len() > 0.0) {} else { // TODO(aliamir): remove
            globalPosition = GlobalPosition()
            globalPosition.o = Orientation(u: Point3D(x: 1.0, y: 0.0, z: 0.0), v: Point3D(x: 0.0, y: 0.0, z: 1.0))*/
        globalPosition = GlobalPosition(p: position, o: orientation)
        //}
        return globalPosition
        
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
