//
//  MapViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation
import MapKit

class MapViewModel: NSObject {
  lazy var location: CLLocation? = locationManager.location
    
  var annotations: [FerryAnnotation] {
    return mapModel.ferries.map { ferry in
      let state: DepartureState = ferry.name == "906" ? .available : .unavailable
      return FerryAnnotation(ferry.endpoints.northLocation.coordinate, title: ferry.name, state: state)
    }
  }
  
  var centerPoint: CLLocationCoordinate2D {
    return mapModel.centerPoint.coordinate
  }
  
  @Published var ferryRoutes: [MKRoute] = []
  
  private var locationManager = CLLocationManager()
  
  private var lastKnownLocation: CLLocation?
  
  private let mapModel = MockMapModel()
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    
    locationManager.startUpdatingLocation()
    updateFerryRoutes()
  }
  
  func updateFerryRoutes() {
    let endpoints = mapModel.ferries.compactMap { $0.endpoints }
    guard let endpoint = endpoints.first else { return }

    let request = MKDirections.Request()
    let sourcePlacemark = MKPlacemark(coordinate: endpoint.northLocation.coordinate)
    request.source = MKMapItem(placemark: sourcePlacemark)
    let destinationPlacemark = MKPlacemark(coordinate: endpoint.southLocation.coordinate)
    request.destination = MKMapItem(placemark: destinationPlacemark)
    request.transportType = .walking
    let directions = MKDirections(request: request)
    // TODO(ss): we might need to custom draw this
    directions.calculate { [weak self] response, error in
      guard let response = response else { return }
//      self?.ferryRoutes = response.routes
    }
  }
  
  func updateTravelTimes(for userLocation: CLLocation) {
    // TODO(ss): need to know if user is on north or south side
    let ferryLocations = mapModel.ferries.map { $0.endpoints.northLocation }
    for ferryLocation in ferryLocations {
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
      request.destination = MKMapItem(placemark: MKPlacemark(coordinate: ferryLocation.coordinate))
      request.transportType = .walking
      let directions = MKDirections(request: request)
      directions.calculate { response, error in
        guard let response = response else { return } // TODO(ss): handle error
        print("=====", response.routes.first?.expectedTravelTime)
      }
    }
  }
}

extension MapViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let userLocation = locations.first else { return }

    // Don't calculate if the user's location hasn't changed
    guard userLocation != lastKnownLocation else { return }

    lastKnownLocation = userLocation
    updateTravelTimes(for: userLocation)
  }
}

struct MockMapModel {
  
  var ferries: [Ferry] {
    return [ndsmFerry, buiksloterwegFerry]
  }
  
  var ndsmFerry: Ferry {
    return Ferry(name: "906",
                 timeTable: [:],
                 tripDuration: 14.0 * 60.0,
                 endpoints: ndsmFerryEndpoints)

  }

  var buiksloterwegFerry: Ferry {
    return Ferry(name: "901",
                 timeTable: [:],
                 tripDuration: 5.0 * 60.0,
                 endpoints: buiksloterwegFerryEndpoints)
  }
  
  let centerPoint = CLLocation(latitude: 52.388299, longitude: 4.905057)
  
  private var ndsmFerryEndpoints: RouteEndpoint {
    return RouteEndpoint(northLocation: ndsmFerryLocation,
                         southLocation: centraalStationLocation)
  }
  
  private var buiksloterwegFerryEndpoints: RouteEndpoint {
    return RouteEndpoint(northLocation: buiksloterwegFerryLocation,
                         southLocation: centraalStationLocation)
  }
  
  private let ndsmFerryLocation = CLLocation(latitude: 52.401211, longitude: 4.891276)
  private let buiksloterwegFerryLocation = CLLocation(latitude: 52.382217, longitude: 4.903215)
  private let centraalStationLocation = CLLocation(latitude: 52.380633, longitude: 4.899400)
}
