//
//  Fieldbook.swift
//  WildlifeSighting
//
//  Created by Victor Zhong on 1/11/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import Foundation

enum FieldbookModelParseError: Error {
    case results, parsing
}

class Fieldbook {
    let id:         Int
    let name:       String
    let date:       String
    let weather:    String
    let lat:        Double
    let long:       Double
    let details:    String
    
    init(
        id:         Int,
        name:       String,
        date:       String,
        weather:    String,
        lat:        Double,
        long:       Double,
        details:    String
        ) {
        self.id = id
        self.name = name
        self.date = date
        self.weather = weather
        self.lat = lat
        self.long = long
        self.details = details
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let date = dictionary["date"] as? String,
            let weather = dictionary["weather"] as? String,
            let lat = dictionary["lat"] as? Double,
            let long = dictionary["long"] as? Double,
            let details = dictionary["details"] as? String
            else { throw FieldbookModelParseError.parsing }
        
        self.init(
            id: id,
            name: name,
            date: date,
            weather: weather,
            lat: lat,
            long: long,
            details: details
        )
    }
    
    static func sights(from data: Data) -> [Fieldbook]? {
        var sightingsToReturn: [Fieldbook]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [[String : AnyObject]] else {
                throw FieldbookModelParseError.results
            }
            
            for sightsDict in response {
                if let sight = try Fieldbook(from: sightsDict) {
                    sightingsToReturn?.append(sight)
                }
            }
        }
        catch {
            print("Error encountered with \(error)")
        }
        
        return sightingsToReturn
    }
    
    static func postSighting(_ name: String, date: String, weather: String, lat: Double, long: Double, details: String) {
        
        let sightingEntry: [String : Any] = [
            "name" : name,
            "date" : date,
            "weather" : weather,
            "lat" : lat,
            "long" : long,
            "details" : details
        ]
        
        APIRequestManager.manager.postRequest(endPoint: "https://api.fieldbook.com/v1/58757bb45de269040063ab78/sightings", data: sightingEntry)
    }
    
    static func patchOrDeleteSighting(_ id: Int, name: String, date: String, weather: String, lat: Double, long: Double, details: String, method: String = "PATCH") {
        
        let sightingEntry: [String : Any] = [
            "name" : name,
            "date" : date,
            "weather" : weather,
            "lat" : lat,
            "long" : long,
            "details" : details
        ]
        
        APIRequestManager.manager.postRequest(endPoint: "https://api.fieldbook.com/v1/58757bb45de269040063ab78/sightings/\(id)", data: sightingEntry, method: method)
    }
}

 /*
 "id": 7,
 "record_url": "https://fieldbook.com/records/587661bdd806f90400c3cb49",
 "sighting_id": "Sighting 7",
 "name": "Hari",
 "date": "2016-02-10",
 "weather": "Shitty",
 "lat": 10.0231,
 "long": 12.123123,
 "details": "Glasses"
 
 
 */
