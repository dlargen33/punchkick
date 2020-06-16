//
//  Movie.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation

struct MovieFetchResult: Codable {
    var movies: [Movie]?
    var total: String?
    var success: String
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case total = "totalResults"
        case success = "Response"
        case error = "Error"
    }
}

struct Movie: Codable {
    var title: String
    var year: String
    var imdbID: String
    var type: String
    var posterLink: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case posterLink = "Poster"
    }
}
