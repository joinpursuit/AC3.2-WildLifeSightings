//
//  APIRequestManager.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 12/8/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation
import SwiftSpinner


enum HttpMethod: String {
    case patch
    case post
    case get
    case delete
}

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    func postRequest(endPoint: String = "https://api.fieldbook.com/v1/58757bb45de269040063ab78/sightings", data: [String:Any], method: String = "POST") {
        dump(data)
        guard let url = URL(string: endPoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("Basic a2V5LTE6NGNRd3JWNjU1dll2VFF0ZEtvcXk=", forHTTPHeaderField: "Authorization")
        
        do {
            DispatchQueue.main.async {
                SwiftSpinner.show("Uploading to Fieldbook")
            }
            let body = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = body
        } catch {
            print("Error posting body: \(error)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error encountered during post request: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any]
                if let validJson = json {
                    print(validJson)
                }
            } catch {
                print("Error converting json: \(error)")
            }
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
            }.resume()
    }
    
    
        func makeRequest(httpMethod: HttpMethod, endpoint: String, bodyDict: [String: Any] = [:], completionHandler: @escaping (URLResponse, Data) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic a2V5LTE6NGNRd3JWNjU1dll2VFF0ZEtvcXk=", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod.rawValue.uppercased()
        
        if httpMethod == .post || httpMethod == .patch {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
            }
            catch {
                print("Error converting to data: \(error)")
                return
            }
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
            }
            if let response = response, let data = data {
                completionHandler(response, data)
            }
            }.resume()
    }
}


    

