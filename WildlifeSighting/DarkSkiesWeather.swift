//
//  DarkSkiesWeather.swift
//  WildlifeSighting
//
//  Created by Victor Zhong on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import Foundation

enum DarkSkiesModelError: Error {
    case response, result, summary, temperature
}

class DarkSkiesWeather {
    var summary: String
    var temp: Double
    
    init(summary: String, temp: Double) {
        self.summary = summary
        self.temp = temp
    }
    
    init?(from dictionary:[String:Any]) {
        guard let result = dictionary["currently"] as? [String : Any],
            let summary = result["summary"] as? String,
            let temperature = result["temperature"] as? Double
            else { return nil }
        
        self.summary = summary
        self.temp = temperature
    }
    
    static func getWeather(from dict:[String:Any]) -> DarkSkiesWeather? {
        
        if let weather = DarkSkiesWeather(from: dict) {
            return weather
        }
        return nil
    }
    
    //    static func getWeather (from data: Data) -> DarkSkiesWeather? {
    //
    //        do {
    //            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
    //            guard let response = jsonData as? [ String : Any ] else { throw DarkSkiesModelError.response }
    //            guard let result = response["currently"] as? [ String : Any ] else { throw DarkSkiesModelError.result }
    //            guard let summary = result["summary"] as? String else { throw DarkSkiesModelError.summary }
    //            guard let temperature = result["temperature"] as? Double else { throw DarkSkiesModelError.temperature }
    //
    //            return DarkSkiesWeather(summary:summary, temp:temperature)
    //
    //        }
    //
    //        catch {
    //            print(error)
    //        }
    //
    //        return nil
    //    }
    
    
}


/*
 {
 "latitude": 37.8267,
 "longitude": -122.4233,
 "timezone": "America/Los_Angeles",
 "offset": -8,
 "currently": {
 "time": 1483999581,
 "summary": "Mostly Cloudy",
 "icon": "partly-cloudy-day",
 "nearestStormDistance": 10,
 "nearestStormBearing": 357,
 "precipIntensity": 0,
 "precipProbability": 0,
 "temperature": 56.42,
 "apparentTemperature": 56.42,
 "dewPoint": 49.13,
 "humidity": 0.77,
 "windSpeed": 10.97,
 "windBearing": 222,
 "visibility": 7.88,
 "cloudCover": 0.93,
 "pressure": 1018.13,
 "ozone": 303.6
 },
 */
