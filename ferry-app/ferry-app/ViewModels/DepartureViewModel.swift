//
//  DepartureViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/12/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class DepartureViewModel: ObservableObject {
    
  enum State {
    case available
    case unavailable
  }
  
  let time: Date
  let timeToStartPoint: TimeInterval?
  
  var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: time)
  }
  
  var countdownString: String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]

    formatter.unitsStyle = .abbreviated
    // TODO(ss): this date is going to need to update
    guard let string = formatter.string(from: Date(), to: time) else { return "" }
    return "in \(string)"
  }
  
  var status: State {
    guard let timeToStartPoint = timeToStartPoint else { return .available }
    // TODO(ss): this date is going to need to update
    let arrivalTimeAtStartPoint = Date().addingTimeInterval(timeToStartPoint)
    return time > arrivalTimeAtStartPoint ? .available : .unavailable
  }
  
  var backgroundColor: Color {
    switch status {
    case .available:
      return .gray
    case .unavailable:
      return Color.gray.opacity(0.5)
    }
  }
  
  var textColor: Color {
    switch status {
    case .available:
      return .white
    case .unavailable:
      return Color.white.opacity(0.5)
    }
  }
  
  init(time: Date, timeToStartPoint: TimeInterval?) {
    self.time = time
    self.timeToStartPoint = timeToStartPoint
  }
}

extension DepartureViewModel: Identifiable {
  typealias ID = String
  
  var id: ID {
    return timeString
  }
}
