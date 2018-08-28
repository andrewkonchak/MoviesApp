//
//  MoviesParameter.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/1/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

protocol MovieParameter {
   
    var key: String { get }
    var rawValue: Any { get }
}

typealias MovieParameters = [MovieParameter]

extension Sequence where Element == MovieParameter {
    
    func toDictionary() -> [String: Any] {
        var payload: [String: Any] = [:]
        for parameter in self {
            payload[parameter.key] = parameter.rawValue
        }
        return payload
    }
}













