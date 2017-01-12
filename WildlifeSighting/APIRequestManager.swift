//
//  APIRequestManager.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 12/8/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

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


    

