//
//  MoviesModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct MoviesModel: Decodable {
    
    let Title: String?
    let fulltitle: String?
    let movie_year: String?
    let Categories: String?
    let summary: String?
    //let ImageURL: String?
    let imdb_id: String?
    let imdb_rating: String?
    let runtime: String?
    let language: String?
    let ytid: String?
}
