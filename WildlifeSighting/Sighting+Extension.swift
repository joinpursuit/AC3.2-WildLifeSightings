//
//  Sighting+Extension.swift
//  WildlifeSighting
//
//  Created by Tom Seymour on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import Foundation
import CoreLocation

extension Sighting {
    
    var dateAndTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date as! Date)
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date as! Date)
    }
    
    var dateString: String {
        let date = self.date!
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let objectDateString = formatter.string(from: date as Date)
        let todayDateString = formatter.string(from: NSDate() as Date)
        if objectDateString == todayDateString {
            return "Today"
        }
        return objectDateString
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    
}


