//
//  FerryAnnotation.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation
import MapKit

class FerryAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  
  init(_ coordinate: CLLocationCoordinate2D, title: String? = nil) {
    self.coordinate = coordinate
    self.title = title
  }
}
