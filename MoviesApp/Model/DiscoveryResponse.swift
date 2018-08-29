//
//  MoviesModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct DiscoveryResponse: Decodable {
    
    let results: [DiscoveryMovieModel]
    let page: Int
    let total_pages: Int
    
    struct DiscoveryMovieModel: Decodable {
        
        let id: Int?
        let year: Int?
        let adult: Bool?
        let title: String?
        let video: Bool?
        let overview: String?
        let genre_ids: [Int]?
        let vote_count: Int?
        let popularity: Double?
        let with_people: String?
        let poster_path: String?
        let vote_average: Double
        let release_date: String?
        let backdrop_path: String? // Full image like poster
        let original_title: String?
        let original_language: String?
        let primary_release_year: Int?
        
    }
}


