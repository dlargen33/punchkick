//
//  Endpoint.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation

class Endpoint {
    enum EndpointError : LocalizedError {
        case invalidRoute(String)
        case serverError
        case noData
        
        var errorDescription: String? {
            switch self {
            case .invalidRoute(let msg):
                return msg
            case .serverError:
                return "Request failed with a non success status code."
            case .noData:
                return "Request resulted in no data in the response"
            }
        }
    }
    
   func get(host: String, parameters:[String: Any]?, completion:@escaping (Result<Data, Error>) -> Void ) {
        var routeWithQueryString = ""
        if let params = parameters {
            for(key, value) in params {
                routeWithQueryString = "\(routeWithQueryString)&\(key)=\(value)"
            }
        }
        
        guard let encoded = routeWithQueryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let routeURL = URL(string:"\(host)?\(encoded)") else {
                completion(.failure(EndpointError.invalidRoute("\(host)\(routeWithQueryString)")))
                return
        }
        
        let session = URLSession(configuration: self.createConfig())
        var request = URLRequest(url: routeURL);
        request.httpMethod = "GET"
    
        let sessionDataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, urlSessionError:Error?) -> Void in
            if let error = urlSessionError {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(EndpointError.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(EndpointError.noData))
                return
            }
            
            completion(.success(data))
        })
        
        sessionDataTask.resume()
            
    }
    
    private func createConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        //var headers = ["Content-Type": "application/json-patch+json"]
        //headers["Accept"] = "application/json"
        //config.httpAdditionalHeaders = headers
        config.timeoutIntervalForRequest = 30
        config.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        config.httpShouldUsePipelining  = true
        config.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        return config
      }
}

