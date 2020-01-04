//
//  FerryAnnotation.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation
import MapKit

// TODO(ss): better naming
enum DepartureState {
  case available
  case risky
  case unavailable
}

class FerryAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?
  let state: DepartureState
  
  init(_ coordinate: CLLocationCoordinate2D, title: String? = nil, state: DepartureState = .unavailable) {
    self.coordinate = coordinate
    self.title = title
    self.state = state
  }
}
