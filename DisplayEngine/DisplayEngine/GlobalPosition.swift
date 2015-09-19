//
//  GlobalPosition.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation

struct Point3D {
  var x = 0.0
  var y = 0.0
  var z = 0.0
}

/**
 * Contains information about the orientation of some object. In case of a
 * phone, u = faces to the right when looking at the screen, v = faces up when
 * looking at the screen, w = faces outwards when looking at the screen.
 * w = v x u (cross product). All of the vectors are unit length.
 **/
struct Orientation {
  var u = Point3D()
  var v = Point3D()
  var w = Point3D()
}

/**
 * Structure that holds the essential position/orientation values, like x, y, z,
 * and orientation details. The accelerometer/gyroscope tracker should return an
 * instance of this struct.
 **/
struct GlobalPosition {
  let p = Point3D()
  let o = Orientation()
}
