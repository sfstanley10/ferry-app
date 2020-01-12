//
//  Holidays.swift
//  ferry-app
//
//  Created by Marieke Montgomery on 12/01/2020.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import Foundation

struct Holidays {

  private static var holidays: [Date] {
    let url = Bundle.main.url(forResource: "holidays2020", withExtension: "json")!
    guard let data = try? Data(contentsOf: url) else { return [] }

    let decoder = JSONDecoder()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "nl_NL")
    dateFormatter.timeZone = TimeZone(identifier: "UTC")!

    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return (try? decoder.decode([Date].self, from: data)) ?? []
  }
  
  static func contains(_ date: Date) -> Bool {
    return holidays.contains(date)
  }
}
