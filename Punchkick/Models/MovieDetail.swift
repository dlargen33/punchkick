//
//  MovieDetail.swift
//  Punchkick
//
//  Created by Donald Largen on 6/15/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    var title: String
    var year: String
    var rated: String
    var released: String
    var runtime: String
    var genre: String
    var director: String
    var writer: String
    var actors: String
    var plot: String
    var language: String
    var country: String
    var awards: String
    var posterLink: String
    var metascore: String
    var imdbRating: String
    var imdbVotes: String
    var type: String
    var toDVD: String
    var boxOfficeRevenue: String
    var production: String
    var success: String
    
     enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case posterLink = "Poster"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case type = "Type"
        case toDVD = "DVD"
        case boxOfficeRevenue = "BoxOffice"
        case production = "Production"
        case success = "Response"
    }
}
