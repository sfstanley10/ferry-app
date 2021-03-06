//
//  LocationService.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/4/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import MapKit
import CoreLocation
import Combine

class LocationService: NSObject {
  
  enum Direction {
    case north
    case south
    case unknown
  }

  var userLocation: AnyPublisher<CLLocation?, Error> {
    return _userLocation.eraseToAnyPublisher()
  }
  var userDirection: AnyPublisher<Direction, Error> {
    return userLocation
      .map { $0?.direction ?? .unknown }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  private var _userLocation = CurrentValueSubject<CLLocation?, Error>(nil)
  private var locationManager = CLLocationManager()

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    
    locationManager.startUpdatingLocation()
  }
  
  func getDirections(from startLocation: CLLocation,
                     to endLocation: CLLocation) -> AnyPublisher<MKRoute, Error> {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: startLocation.coordinate))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endLocation.coordinate))
    request.transportType = .walking
    let directions = MKDirections(request: request)
    return Future<MKRoute, Error> { promise in
      directions.calculate { response, error in
        guard let response = response else {
          promise(.failure(error ?? LocationServiceError.unknownError))
          return
        }
        guard let route = response.routes.first else {
          promise(.failure(LocationServiceError.noRouteError))
          return
        }
        return promise(.success(route))
      }
    }.eraseToAnyPublisher() 
  }
  
  func getDirections(fromCurrentLocationTo endLocation: CLLocation) -> AnyPublisher<MKRoute, Error> {
    return userLocation
      .flatMap { [weak self] userLocation -> AnyPublisher<MKRoute, Error> in
        guard let self = self, let userLocation = userLocation else {
          return Fail<MKRoute, Error>(error: NoSelfError()).eraseToAnyPublisher()
        }
        return self.getDirections(from: userLocation, to: endLocation)
      }
      .eraseToAnyPublisher()
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first, location.coordinate != _userLocation.value?.coordinate else { return }
    _userLocation.send(location)
  }
}

enum LocationServiceError: Error {
  case unknownError
  case noRouteError
}

extension CLLocation {
  var direction: LocationService.Direction {
    guard let isNorthOfRiver = coordinate.isNorthOfIJRiver else { return .unknown }
    return isNorthOfRiver ? .north : .south
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
