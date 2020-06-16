//
//  MovieSearchViewModel.swift
//  Punchkick
//
//  Created by Donald Largen on 6/14/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation
import UIKit

class MovieSearchViewModel {

    private let movieService = MovieService()
    private var movies: [Movie] = []

      func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return movies.count
    }
    
    func movieTitle(at indexPath: IndexPath) -> String? {
        guard indexPath.row < movies.count  else { return nil }
        return movies[indexPath.row].title
    }
    
    func movieImage(at indexPath: IndexPath, completion: @escaping (UIImage, IndexPath?) -> Void) {
        guard indexPath.row < movies.count  else { return }
        let movie = movies[indexPath.row]
        movieService.image(with: ImageRequest(url: movie.posterLink, indexPath: indexPath)) { (result) in
            switch result {
            case .success(let imageResult):
                completion(imageResult.image, imageResult.indexPath)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func search(for search: String, completion: @escaping (Result<Void, Error>) -> Void){
        movieService.search(for: search) { (result) in
            switch result {
            case .success(let movies) :
                self.movies = movies
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
    
    func movieDetail(at indexPath: IndexPath, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        guard indexPath.row < movies.count  else { return }
        let movie = movies[indexPath.row]
        movieService.movieDetail(id: movie.imdbID, completion: completion)
    }
}
