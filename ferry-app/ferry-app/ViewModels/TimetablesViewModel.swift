//
//  TimetablesViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 1/4/20.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import Combine

class TimetablesViewModel: ObservableObject {
  
  let objectWillChange = PassthroughSubject<Void, Never>()
  
  var directionTitle: String {
    switch locationService.userDirection {
    case .north:
      return "Southbound"
    case .south:
      return "Northbound"
    case .unknown:
      return ""
    }
  }
  
  lazy var ferries: [FerryViewModel] = {
    return mapModel.ferries.map { FerryViewModel(ferry: $0, locationService: locationService) }
  }()
  
  private let mapModel: MockMapModel
  private let locationService: LocationService
  private var locationSubscription: AnyCancellable?
  
  init(mapModel: MockMapModel = MockMapModel(),
       locationService: LocationService = LocationService()) {
    self.mapModel = mapModel
    self.locationService = locationService
    
    let locationUpdated = locationService.$userLocation
      .map { _ in return }
      .eraseToAnyPublisher()
    
    let publishers = ferries.map { $0.objectWillChange }
    let ferriesUpdated = Publishers.MergeMany(publishers)
      .eraseToAnyPublisher()
    
    // TODO(ss): p sure this doesn't work cuz the ferry updaters rely on location updates?
    // either that or we have some kind of race condition
    locationSubscription = Publishers.CombineLatest(locationUpdated, ferriesUpdated)
      .print("=====")
      .map { _ in return }
      .subscribe(objectWillChange)
  }
}
