//
//  DateExtensions.swift
//  ferry-app
//
//  Created by Marieke Montgomery on 12/01/2020.
//  Copyright © 2020 Sydnee Stanley. All rights reserved.
//

import Foundation

extension Date {
  var isHoliday: Bool {
    return Holidays.contains(self)
  }
}
