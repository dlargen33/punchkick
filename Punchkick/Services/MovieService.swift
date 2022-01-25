//
//  MovieService.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation
import UIKit

struct ImageRequest {
    var url: String
    var indexPath: IndexPath?
}

struct ImageResult {
    var image: UIImage
    var indexPath: IndexPath?
}

class MovieService {
    
    enum MovieServiceError: LocalizedError {
        case serviceFailure(String)
        
        var errorDescription: String? {
            switch self {
            case .serviceFailure(let msg):
                return msg
            }
        }
    }
    
    private  let apiHost: String = "https://www.omdbapi.com/"
    private  let apiKey = "1ea41bc1"
    private  let resultType = "movie"
    private let cache = NSCache<NSString, AnyObject>()
    
    func search(for criteria: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        print("Called Search with criteria: \(criteria)")
        var params = ["apikey" : apiKey]
        params ["type"] = resultType
        params["s"] = criteria
       
        let endPoint = Endpoint()
        endPoint.get(host: apiHost, parameters:params) { (result) in
        
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let fetchResult = try decoder.decode(MovieFetchResult.self, from: data)
                    
                    guard let success = Bool(fetchResult.success.lowercased()), success == true, let movies = fetchResult.movies  else {
                                    
                        guard let message = fetchResult.error else  {
                            DispatchQueue.main.async {
                                  completion(.failure(MovieServiceError.serviceFailure("Failed to search for movies.")))
                            }
                            return
                         }
                        
                        DispatchQueue.main.async {
                            completion(.failure(MovieServiceError.serviceFailure(message)))
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(movies))
                    }
                }
                catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func movieDetail(id: String,  completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        var params = ["apikey" : apiKey]
        params["i"] = id
              
        let endPoint = Endpoint()
        endPoint.get(host: apiHost, parameters:params) { (result) in
       
           switch result {
           case .success(let data):
               do {
                   let decoder = JSONDecoder()
                   let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                   
                   guard let success =  Bool(movieDetail.success.lowercased()), success == true else {
                        DispatchQueue.main.async {
                            completion(.failure(MovieServiceError.serviceFailure("Failed to get movie detail.")))
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                       completion(.success(movieDetail))
                   }
               }
               catch {
                   print(error)
                   DispatchQueue.main.async {
                       completion(.failure(error))
                   }
               }
           case .failure(let error):
               DispatchQueue.main.async {
                   completion(.failure(error))
               }
           }
        }
    }
    
    func image(with request:ImageRequest, completion: @escaping (Result<ImageResult, Error>) -> Void) {
        
        //check to see if it is in cache.
        if let data = cache.object(forKey: request.url as NSString)  as? Data, let image = UIImage(data: data) {
            let imageResult = ImageResult(image: image, indexPath: request.indexPath)
            completion(.success(imageResult))
            return
        }
        
        let endPoint = Endpoint()
        endPoint.get(host: request.url, parameters: nil) { (result) in
            switch result {
            case .success(let data):
                //store in cache to use later.
                self.cache.setObject(data as NSData, forKey: request.url as NSString)
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else {
                        completion(.failure(MovieServiceError.serviceFailure("Failed to convert \(request.url) to an UIImage")))
                        return
                    }
                    let imageResult = ImageResult(image: image,  indexPath: request.indexPath)
                    completion(.success(imageResult))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
