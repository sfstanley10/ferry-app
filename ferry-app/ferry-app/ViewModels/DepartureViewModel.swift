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
  
  let timeString: String
  let status: State
  
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
    self.status = status
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    self.timeString = formatter.string(from: time)
  }
}

extension DepartureViewModel: Identifiable {
  typealias ID = String
  
  var id: ID {
    return timeString
  }
}
