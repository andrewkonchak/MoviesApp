//
//  SettingsManager.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/8/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation

final class SettingsManager {
    
    static let shared = SettingsManager()
    
    private(set) var filters = [MoviesFilter.year(2019)]
    private(set) var sortParameter = MovieSortParameter.name(.ascending)
    
    func setFilters(_ filters: [MoviesFilter]) {
        self.filters = filters
    }
    
    func setSortParameters(_ parameter: MovieSortParameter) {
        sortParameter = parameter
    }
    
    func getParameters() -> [MovieParameter] {
        return filters + [sortParameter]
    }
    
}
