//
//  MoviesApi.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (MoviesModel?) -> ()
typealias Filter = (key: String, value: String)

class MoviesApi {

    static let shared = MoviesApi()
    let moviesMod = MoviesModel.self
    
    enum Constants {
        static let baseUrlString = "https://hydramovies.com/api-v2/?source=http://hydramovies.com/api-v2/current-Movie-Data.csv"
    }

    func downloadMovies(filter: [Filter], sort: String, completionHandler: @escaping CompletionHandler) {
        Alamofire.request(Constants.baseUrlString + "&\(filter)=\(sort)").responseJSON { (response) in
            print(response)
           
            DispatchQueue.main.async {
                guard let data = response.data else { return }
                
                do {
                    let moviesDescription = try JSONDecoder().decode(self.moviesMod, from: data)
                    completionHandler(moviesDescription)
                    
                } catch {}
            }
        }.resume()
    }
}
