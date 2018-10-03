//
//  MovieDetailModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 10/2/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct MovieDetailModel: Decodable {
    
    let backdrop_path: String?
    let budget: Int?
    let genres: [Genres]
    
    struct Genres: Decodable {
        let id: Int?
        let name: String?
    }
    
    let homepage: String?
    let id: Int?
    let imdb_id: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [Companies]
    
    struct Companies: Decodable {
        let id: Int?
        let logo_path: String?
        let name: String?
        let origin_country: String?
    }
    
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [Languages]
    
    struct Languages: Decodable {
        let iso_639_1: String?
        let name: String?
    }
    
    let status: String?
    let tagline: String?
    let title: String?
    let vote_average: Double?
    let vote_count: Int?
}
    
    

