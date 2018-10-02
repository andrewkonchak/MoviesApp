//
//  MovieDetailModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 10/2/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct MovieDetailModel: Decodable {
    
    let backdrop_path: String
    let budget: Int
    let genres: [Genres]
    
    struct Genres: Decodable {
        
        let id: Int
        let name: String
    }
    
    let homepage: String
    let id: String
    let imdb_id: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Int
    let poster_path: String
    let production_companies: [Companies]
    
    struct Companies: Decodable {
        let id: Int
        let logo_path: String
        let name: String
        let origin_country: String
    }
    
    let release_date: String
    let revenue: Int
    let runtime: Int
   
//    "spoken_languages": [
//    {
//    "iso_639_1": "en",
//    "name": "English"
//    }
//    ],
//    "status": "Released",
//    "tagline": "Never tell him the odds.",
//    "title": "Solo: A Star Wars Story",
//    "video": false,
//    "vote_average": 6.7,
//    "vote_count": 1954
}
    
    

