//
//  MapViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation
import MapKit
import Combine

class MapViewModel {
    
  var annotations: [FerryAnnotation] {
    return mapModel.ferries.map { ferry in
      let state: DepartureState = ferry.name == "906" ? .available : .unavailable
      return FerryAnnotation(ferry.endpoints.northLocation.location.coordinate,
                             title: ferry.name,
                             state: state)
    }
  }
  
  var centerPoint: CLLocationCoordinate2D {
    return mapModel.centerPoint.coordinate
  }
  
  // TODO(ss): Route used to draw the ferry
  @Published var ferryRoutes: [MKRoute] = []
  
  var topFerryRoutes: AnyPublisher<[MKRoute], Error> {
    let count = mapModel.ferries.count
    return locationService.$userLocation
      .compactMap { $0 }
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
      .flatMap { [weak self] location -> Publishers.Sequence<[AnyPublisher<MKRoute, Error>], Error> in
        let sequence = self?.ferryDirections(from: location) ?? []
        return Publishers.Sequence<[AnyPublisher<MKRoute, Error>], Error>(sequence: sequence)
      }
      .flatMap { $0 }
      .collect(count)
      .eraseToAnyPublisher()
  }
  
  func ferryLocations(from location: CLLocation) -> [CLLocation] {
    switch location.direction {
    case .north:
      return mapModel.ferries.map { $0.endpoints.northLocation.location }
    case .south:
      return mapModel.ferries.map { $0.endpoints.southLocation.location }
    case .unknown:
      return []
    }
  }
  
  func ferryDirections(from location: CLLocation) -> [AnyPublisher<MKRoute, Error>] {
    return ferryLocations(from: location).map {
      locationService.getDirections(from: location, to: $0)
    }
  }
      
  private let mapModel: MockMapModel
  private let locationService: LocationService
  
  private var userLocationSubscription: AnyCancellable?
  
  init(mapModel: MockMapModel = MockMapModel(),
       locationService: LocationService = LocationService()) {
    self.mapModel = mapModel
    self.locationService = locationService
  }
}

struct NoSelfError: Error {}
