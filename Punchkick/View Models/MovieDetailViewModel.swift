//
//  MovieDetailViewModel.swift
//  Punchkick
//
//  Created by Donald Largen on 6/15/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewModel {
    
    private let movieDetail: MovieDetail
    private let movieService: MovieService = MovieService()
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
    
    func movieImage( completion: @escaping (Result<UIImage, Error>) -> Void) {
        movieService.image(with: ImageRequest(url: movieDetail.posterLink)) { (result) in
            switch result {
            case .success(let imageResult) :
                completion(.success(imageResult.image))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
    
    var movieTitle: String {
        return movieDetail.title
    }
    
    var score: String {
        return "Metacritic Score \(movieDetail.metascore)"
    }
    
    var plot: String {
        return movieDetail.plot
    }
}
