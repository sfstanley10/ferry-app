//
//  FerryViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/4/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class FerryViewModel: ObservableObject {
  
  var objectWillChange = PassthroughSubject<Void, Never>()
  
  var name: String {
    return ferry.name
  }
  
  var timeToStartPointString: String {
    guard let seconds = secondsToStartPoint else { return "ETA unavailable" }
    return "\(Int(seconds / 60)) min away"
  }
  
  var startPointName: String {
    return startPoint?.name ?? ""
  }
  
  var endPointName: String {
    return endPoint?.name ?? ""
  }
  
  var departures: [DepartureViewModel] {
    let times: [Date]
    // TODO(ss): getting .unknown here
    switch direction {
    case .north:
      times = ferry.availableTimes(forDirection: .southBound, after: Date())
    case .south:
      times = ferry.availableTimes(forDirection: .northBound, after: Date())
    case .unknown:
      times = []
    }
    return times.map { DepartureViewModel(time: $0, status: .available) } // TODO(ss)
  }
  
  private func startPoint(from location: CLLocation?) -> RouteEndpoints.Endpoint? {
    guard let location = location else { return nil }
    switch location.direction {
    case .north:
      return self.ferry.endpoints.northLocation
    case .south:
      return self.ferry.endpoints.southLocation
    case .unknown:
      return nil
    }
  }
  
  private var startPoint: RouteEndpoints.Endpoint? {
    switch direction {
    case .south:
      return ferry.endpoints.southLocation
    case .north:
      return ferry.endpoints.northLocation
    case .unknown:
      return ferry.endpoints.northLocation // TODO(ss)
    }
  }
  
  private var endPoint: RouteEndpoints.Endpoint? {
    switch direction {
    case .north:
      return ferry.endpoints.southLocation
    case .south:
      return ferry.endpoints.northLocation
    case .unknown:
      return ferry.endpoints.southLocation // TODO(ss)
    }
  }
  
  // TODO(ss): is there a better way to do this?
  private var secondsToStartPoint: TimeInterval? = nil {
    didSet {
      objectWillChange.send()
    }
  }
  private var direction: LocationService.Direction = .unknown {
    didSet {
      guard oldValue != direction else { return }
      objectWillChange.send()
    }
  }
  
  private var disposables = Set<AnyCancellable>()
  
  private var ferry: Ferry
  private var locationService: LocationService
  
  init(ferry: Ferry,
       locationService: LocationService) {
    self.ferry = ferry
    self.locationService = locationService
    getExpectedTravelTime()
    updateFerryDirection()
  }
  
  func getExpectedTravelTime() {
    locationService.userLocation
      .catch { _ in return Just(nil) }
      .map { [weak self] location -> (CLLocation?, RouteEndpoints.Endpoint?) in
        return (location, self?.startPoint(from: location))
      }
      .flatMap { [weak self] (userLocation, startPoint) -> AnyPublisher<TimeInterval?, Never> in
        guard let self = self, let userLocation = userLocation, let startPoint = startPoint else {
          return Just(nil).eraseToAnyPublisher()
        }
        return self.locationService
          .getDirections(from: userLocation, to: startPoint.location)
          .map { $0.expectedTravelTime }
          .replaceError(with: nil)
          .eraseToAnyPublisher()
      }
      .sink(receiveValue: { [weak self] eta in
        guard let eta = eta else { return }
        self?.secondsToStartPoint = eta
      })
      .store(in: &disposables)
  }
  
  func updateFerryDirection() {
    locationService.userDirection
      .catch { _ in return Just(.unknown) }
      .sink { [weak self] direction in
        self?.direction = direction
      }
      .store(in: &disposables)
  }
}

extension FerryViewModel: Identifiable {
  typealias ID = String
  
  var id: ID {
    return name
  }
}
