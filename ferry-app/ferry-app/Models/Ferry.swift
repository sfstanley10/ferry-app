//
//  Ferry.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/14/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import Foundation
import CoreLocation

struct Ferry {
  
  enum Direction {
    case northBound
    case southBound
  }
  
  let name: String
  let timeTable: [Direction: [Schedule]]
  let tripDuration: TimeInterval
  let endpoints: RouteEndpoint
  
  func schedule(forDirection direction: Direction, date: Date) -> Schedule? {
    guard let schedules = timeTable[direction] else { return nil }
    return schedules.first(where: { $0.applies(to: date) })
  }
  
  func availableTimes(forDirection direction: Direction, after date: Date) -> [Date] {
    guard let currentSchedule = schedule(forDirection: direction, date: date) else { return [] }
    return currentSchedule.timesAfter(date)
  }
  
  func startPoint(for direction: Ferry.Direction) -> CLLocation {
    switch direction {
    case .northBound:
      return endpoints.southLocation
    case .southBound:
      return endpoints.northLocation
    }
  }
  
  func endPoint(for direction: Ferry.Direction) -> CLLocation {
    switch direction {
    case .northBound:
      return endpoints.northLocation
    case .southBound:
      return endpoints.southLocation
    }
  }
}
