//
//  DarkSkiesWeather.swift
//  WildlifeSighting
//
//  Created by Victor Zhong on 1/9/17.
//  Copyright © 2017 Sabrina, Vic, Tom. All rights reserved.
//

import Foundation

enum DarkSkiesModelError: Error {
    case response, result, summary, temperature, initFaliure
}

class DarkSkiesWeather {
    var summary: String
    var temp: Double
    
    init(summary: String, temp: Double) {
        self.summary = summary
        self.temp = temp
    }
    
    init?(from dictionary:[String:Any]) throws {
        guard let result = dictionary["currently"] as? [String : Any],
            let summary = result["summary"] as? String,
            let temperature = result["temperature"] as? Double
            else { return nil }
        
        self.summary = summary
        self.temp = temperature
    }
    
    static func getWeather(from data: Data) -> DarkSkiesWeather? {
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let responseDict = jsonData as? [ String : Any ] else { throw DarkSkiesModelError.response }
            if let weather = try DarkSkiesWeather(from: responseDict) {
                return weather
            } else {
                throw DarkSkiesModelError.initFaliure
            }
        }
        catch {
            print(error)
        }
        return nil
    }
}
