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
      return FerryAnnotation(ferry.endpoints.northLocation.coordinate, title: ferry.name, state: state)
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
  
  func ferryLocations(from: CLLocation) -> [CLLocation] {
    return mapModel.ferries.map {
      locationService.isInNorth ? $0.endpoints.northLocation : $0.endpoints.southLocation
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

struct NoSelfError: Error {}
