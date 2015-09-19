//
//  GlobalPosition.swift
//  DisplayEngine
//
//  Created by Ali-Amir Aldan on 9/19/15.
//  Copyright © 2015 Simplex. All rights reserved.
//

import Foundation

/**
 * Structure that holds the essential position/orientation values, like x, y, z,
 * and orientation details. The accelerometer/gyroscope tracker should return an
 * instance of this struct.
 **/
struct GlobalPosition {
  let p = Point3D()
  // TODO(manj): Add the parameters for orientation.
}
