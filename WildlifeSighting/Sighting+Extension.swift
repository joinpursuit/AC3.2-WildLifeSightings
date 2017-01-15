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
    
    var postDate: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        return dateformatter.string(from: self.date as! Date)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    var firstLetter: String {
        return String(self.name!.characters.first!)
    }
    
    var weatherString: String {
        return self.weatherDescription ?? "?"
    }
    
    
    // this solution is a hack. I want to add another field to core data to save a 'waetherType', which comes from the DarkSkies API and create an enum out of it.
    var weatherEmoji: String {
        if let weather = weatherDescription {
            switch weather {
            case "Snow":
                return "🌨"
            case "Rain":
                return "🌧"
            case "Partly Cloudy":
                return "⛅️"
            case "Overcast":
                return "☁️"
            case "Mostly Cloudy":
                return "🌥"
            case "Light Rain":
                return "🌦"
            case "Sunny", "Sun":
                return "☀️"
            default:
                return ""
            }
        }
        return ""
    }
}


