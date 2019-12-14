//
//  MapViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation

class MapViewModel {
  lazy var location: CLLocation? = locationManager.location
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestWhenInUseAuthorization()
    return manager
  }()
  
  let mapModel = MockMapModel()
  
  var mockAnnotations: [FerryAnnotation] {
    return mapModel.ferryLocations.flatMap { $0.value.map { FerryAnnotation($0.coordinate) } }
  }
  
  var centerPoint: CLLocationCoordinate2D {
    return mapModel.centerPoint.coordinate
  }
}

struct MockMapModel {
  enum Direction {
    case northBound
    case southBound
  }
  
  let NDSMFerryLocation = CLLocation(latitude: 52.401211, longitude: 4.891276)
  let BuiksloterwegFerryLocation = CLLocation(latitude: 52.382217, longitude: 4.903215)
  
  let centerPoint = CLLocation(latitude: 52.388299, longitude: 4.905057)
  
  var ferryLocations: [Direction: [CLLocation]] {
    return [.southBound: [NDSMFerryLocation, BuiksloterwegFerryLocation]]
  }
}
