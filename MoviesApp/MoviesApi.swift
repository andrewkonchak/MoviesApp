//
//  MoviesApi.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation
import Alamofire

typealias DownloadComplete = () -> ()

class MoviesApi {

    enum Constants {
        static let baseUrlString = "https://hydramovies.com/api-v2/?source=http://hydramovies.com/api-v2/current-Movie-Data.csv"
        static let shared = MoviesApi()
    }

    func downloadMovies(completion: @escaping DownloadComplete) {
        Alamofire.request(Constants.baseUrlString).responseJSON { (response) in
            print(response)
        }
    }
    
}
