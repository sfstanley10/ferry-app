//
//  Ferry.swift
//  ferry-app
//
//  Created by Marieke Montgomery on 23/11/2019.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import Foundation
import CoreLocation

struct Ferry {
    
    enum Direction {
        case toNorth
        case toSouth
    }
    
    var tripDuration: TimeInterval
    var departureTimes: [Direction: [DateComponents]]
    var location: [Direction: CLLocation]
    var name: String
    
    
    

}
