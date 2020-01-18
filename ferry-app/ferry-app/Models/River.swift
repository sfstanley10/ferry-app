//
//  River.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/18/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import CoreGraphics
import CoreLocation

/// An object that represents a piecewise function to simulate the IJ river.
final class River {
  
  /// A sampling of the points along the north side of the IJ river
  private static let points = [CGPoint(x: 4.865239, y: 52.414518),
                               CGPoint(x: 4.896396, y: 52.397291),
                               CGPoint(x: 4.902790, y: 52.381973),
                               CGPoint(x: 4.957164, y: 52.384098)]
  
  static func pointIsNorthOfRiver(_ point: CGPoint) -> Bool? {
    guard let yCoordinate = getPointOnClosestXLine(point) else { return nil }
    return yCoordinate.y <= point.y
  }

  private static func getPointOnClosestXLine(_ point: CGPoint) -> CGPoint? {
    let x = point.x
    for i in 0..<points.count - 1 {
      guard x >= points[i].x && x < points[i+1].x else { continue }
      let yOnLine = getYOnLineBetween(point1: points[i], point2: points[i+1], xValue: x)
      return CGPoint(x: x, y: yOnLine)
    }
    return nil
  }

  private static func getYOnLineBetween(point1: CGPoint, point2: CGPoint, xValue: CGFloat) -> CGFloat {
    let (slope, intersection) = getSlopeAndIntersection(point1: point1, point2: point2)
    return getY(forSlope: slope, intersection: intersection, x: xValue)
  }

  private static func getSlopeAndIntersection(point1: CGPoint, point2: CGPoint) -> (CGFloat, CGFloat) {
    let slope = (point2.y - point1.y) / (point2.x - point1.x)
    let intersection = point1.y - (slope * point1.x)
    return (slope, intersection)
  }

  private static func getY(forSlope slope: CGFloat, intersection: CGFloat, x: CGFloat) -> CGFloat {
    return (slope * x) + intersection
  }
}

extension CLLocationCoordinate2D {
  var isNorthOfIJRiver: Bool? {
    let pointValue = CGPoint(x: longitude, y: latitude)
    return River.pointIsNorthOfRiver(pointValue)
  }
}
