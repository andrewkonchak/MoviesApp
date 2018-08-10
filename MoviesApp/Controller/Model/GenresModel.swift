//
//  GenresModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/6/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct GenresModel: Decodable {
    
    let genres: [Genres]
    
    struct Genres: Decodable {
        
        let id: Int
        let name: String
    }
}
