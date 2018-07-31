//
//  MoviesModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct DiscoveryResponse: Decodable {
    
    let results: [DiscoveryMovieModel]?
    
    struct DiscoveryMovieModel: Decodable {
        let vote_count: Int?
        let id: Int?
        let video: Bool?
        let vote_average: Double?
        let title: String?
        let popularity: Double?
        let poster_path: String?
        let original_language: String?
        let original_title: String?
        let genre_ids: [Int]?
        let backdrop_path: String?
        let adult: Bool?
        let overview: String?
        let release_date: String?
    }
}


