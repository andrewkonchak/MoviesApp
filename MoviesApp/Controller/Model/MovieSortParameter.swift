//
//  MovieSortParameter.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/8/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

enum MovieSortParameter: MovieParameter {
    
    enum Order: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    case name(Order)
    case year(Order)
    case rating(Order)
    case popularity(Order)
    
    var key: String {
        return "sort_by"
    }
    
    var name: String {
        switch self {
        case .name:
            return "original_title"
        case .year:
            return "release_date"
        case .rating:
            return "vote_average"
        case .popularity:
            return "vote_count"
        }
    }
    
    var rawValue: Any {
        switch self {
        case .name(let order),
             .year(let order),
             .popularity(let order),
             .rating(let order):
            return "\(name).\(order.rawValue)"
        }
    }
}
