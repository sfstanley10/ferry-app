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
  let status: State
  
  var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: time)
  }
  
  var countdownString: String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]

    formatter.unitsStyle = .abbreviated
    guard let string = formatter.string(from: Date(), to: time) else { return "" }
    return "in \(string)"
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
  
  init(time: Date, status: State) {
    self.time = time
    self.status = status
  }
}

extension DepartureViewModel: Identifiable {
  typealias ID = String
  
  var id: ID {
    return timeString
  }
}
