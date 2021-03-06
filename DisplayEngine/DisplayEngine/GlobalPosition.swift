//
//  GlobalPosition.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation
import CoreMotion

public struct Point3D {
    var x = 0.0
    var y = 0.0
    var z = 0.0
  
    func add(point: Point3D) -> Point3D {
      return Point3D(x: x+point.x, y: y+point.y, z: z+point.z)
    }
  
    func sub(point: Point3D) -> Point3D {
      return Point3D(x: x-point.x, y: y-point.y, z: z-point.z)
    }
  
    func mul(factor: Double) -> Point3D {
      return Point3D(x: x*factor, y: y*factor, z: z*factor)
    }

    func dot(point: Point3D) -> Double {
      return x*point.x + y*point.y + z*point.z
    }
  
    func cross(point: Point3D) -> Point3D {
      return Point3D(x: y * point.z - z * point.y, y: -(x * point.z - z * point.x), z: x * point.y - y * point.x)
    }
    
    func len() -> Double {
        return sqrt(dot(self))
    }
    
    func len2D() -> Double {
        return sqrt(x*x + y*y)
    }
    
    // rotate about x-axis
    func rotateX(pitch: Double) -> Point3D {
        let newX = x
        let newY = y*cos(pitch) - z*sin(pitch)
        let newZ = y*sin(pitch) + z*cos(pitch)
        return Point3D(x: newX, y: newY, z: newZ)
    }
    
    // rotate about y-axis
    func rotateY(roll: Double) -> Point3D {
        let newX = x*cos(roll) + z*sin(roll)
        let newY = y
        let newZ = z*cos(roll) - x*sin(roll)
        return Point3D(x: newX, y: newY, z: newZ)
    }
    
    // rotate about z-axis
    func rotateZ(yaw: Double) -> Point3D {
        let newX = x*cos(yaw) - y*sin(yaw)
        let newY = x*sin(yaw) + y*cos(yaw)
        let newZ = z
        return Point3D(x: newX, y: newY, z: newZ)
    }
    
    // rotate point about the 3 axes
    func rotate(pitch: Double, roll: Double, yaw: Double) -> Point3D {
        var rotatedPoint = self.rotateX(pitch)
        rotatedPoint = rotatedPoint.rotateY(roll)
        rotatedPoint = rotatedPoint.rotateZ(yaw)
        return rotatedPoint
    }
    
    func rotate(matrix: CMRotationMatrix) -> Point3D {
        let matrixRow1 = Point3D(x: matrix.m11, y: matrix.m21, z: matrix.m31)
        let matrixRow2 = Point3D(x: matrix.m12, y: matrix.m22, z: matrix.m32)
        let matrixRow3 = Point3D(x: matrix.m13, y: matrix.m23, z: matrix.m33)
        return Point3D(x: self.dot(matrixRow1), y: self.dot(matrixRow2), z: self.dot(matrixRow3))
    }
    
    func toString() -> String {
        return "\(x), \(y), \(z)"
    }

}

// Contains information about the orientation of some object. In case of a
// phone, u = faces to the right when looking at the screen, v = faces up when
// looking at the screen, w = faces outwards when looking at the screen.
// w = v x u (cross product). All of the vectors are unit length.
public struct Orientation {
    var u = Point3D()
    var v = Point3D()
    var w: Point3D {
        return v.cross(u)
    }
}

// Structure that holds the essential position/orientation values, like x, y, z,
// and orientation details. The accelerometer/gyroscope tracker should return an
// instance of this struct.
public struct GlobalPosition {
  var p = Point3D()
  var o = Orientation()
}
