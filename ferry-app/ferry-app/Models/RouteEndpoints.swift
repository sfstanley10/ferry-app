//
//  RouteEndpoints.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/4/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import CoreLocation

struct RouteEndpoints {
  
  struct Endpoint {
    var location: CLLocation
    var name: String
  }
  
  var northLocation: Endpoint
  var southLocation: Endpoint
  
  init(northLocation: CLLocation, northLocationName: String,
       southLocation: CLLocation, southLocationName: String) {
    self.northLocation = Endpoint(location: northLocation, name: northLocationName)
    self.southLocation = Endpoint(location: southLocation, name: southLocationName)
  }
}
