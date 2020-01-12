//
//  Schedule.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/14/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import Foundation

struct Schedule {
  let daysOfTheWeek: [DateComponents]
  let times: [DateComponents]
  
  var days: [Int] {
    return daysOfTheWeek.compactMap { $0.weekday }
  }
  
  /// Determines if the current schedule applies to the current date (as in days of the week match)
  func applies(to date: Date) -> Bool {
    guard !date.isHoliday else {
      return days.contains(7)
    }
    let calendar = Calendar.current
    let weekdayComponent = calendar.dateComponents([.weekday], from: date).weekday ?? 0
    return days.contains(weekdayComponent)
  }
  
  func allTimes(inTermsOf date: Date) -> [Date] {
    let calendar = Calendar.current
    guard applies(to: date) else { return [] }
    return times.compactMap { timeComponent in
      guard let scheduledHour = timeComponent.hour, let scheduledMinutes = timeComponent.minute else { return nil }
      return calendar.date(bySettingHour: scheduledHour, minute: scheduledMinutes, second: 0, of: date)
    }
  }
  
  func timesAfter(_ date: Date) -> [Date] {
    let times = allTimes(inTermsOf: date)
    return times.filter { $0 >= date }
  }
}

// TODO(ss): move
extension DateComponents {
  static var weekdays: [DateComponents] {
    return [DateComponents(weekday: 2),
            DateComponents(weekday: 3),
            DateComponents(weekday: 4),
            DateComponents(weekday: 5),
            DateComponents(weekday: 6)]
  }
  
  static var weekends: [DateComponents] {
    return [DateComponents(weekday: 1),
            DateComponents(weekday: 7)]
  }
}
