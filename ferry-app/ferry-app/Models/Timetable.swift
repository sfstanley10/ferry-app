//
//  Timetable.swift
//  ferry-app
//
//  Created by Marieke Montgomery on 12/01/2020.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import CoreLocation

struct Timetable {
  var ferries: [Ferry]
  var holidays: [Date]
}

struct MockMapModel {
  
  var ferries: [Ferry] {
    return [ndsmFerry, buiksloterwegFerry]
  }
  
  var ndsmFerry: Ferry {
    let times = [DateComponents(hour: 7, minute: 00)]
    return Ferry(name: "906",
                 timeTable: [.southBound: [Schedule(daysOfTheWeek: DateComponents.weekends, times: times)]],
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
  
  private var ndsmFerryEndpoints: RouteEndpoints {
    return RouteEndpoints(northLocation: ndsmFerryLocation,
                          northLocationName: "NDSM",
                          southLocation: centraalStationLocation,
                          southLocationName: "Centraal Station")
  }
  
  private var buiksloterwegFerryEndpoints: RouteEndpoints {
    return RouteEndpoints(northLocation: buiksloterwegFerryLocation,
                          northLocationName: "Buiksloterweg",
                          southLocation: centraalStationLocation,
                          southLocationName: "Centraal Station")
  }
  
  private let ndsmFerryLocation = CLLocation(latitude: 52.401211, longitude: 4.891276)
  private let buiksloterwegFerryLocation = CLLocation(latitude: 52.382217, longitude: 4.903215)
  private let centraalStationLocation = CLLocation(latitude: 52.380633, longitude: 4.899400)
}
