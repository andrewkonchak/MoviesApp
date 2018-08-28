//
//  MovieVideoModel.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/22/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

struct MovieVideoModel: Decodable {
    let id: Int?
    let results: [Results]
    
    struct Results: Decodable {
        let key: String
    }
}
