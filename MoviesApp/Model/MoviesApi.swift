//
//  MoviesApi.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/30/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias CompletionHandler = (DiscoveryResponse?) -> ()
typealias GenresHandler = (GenresModel?) -> ()
typealias TrailersHandler = (MovieVideoModel?) -> ()
typealias DetailHandler = (MovieDetailModel?) -> ()

class MoviesApi {

    static let shared = MoviesApi()
    
    enum Constants {
        static let baseUrlString = "https://api.themoviedb.org/3"
        static let apiKey = "fef7899f9aac38745096ad5f347e48ed"
    }

    var pageIndex = 1
    
    //MARK: - Download movies from link
    
    func downloadMovies(parameters: [String : Any], completionHandler: @escaping CompletionHandler) {
        var parameters = parameters
        parameters["api_key"] = Constants.apiKey
        parameters["vote_count.gte"] = 100
        parameters["page"] = pageIndex
        Alamofire.request(Constants.baseUrlString + "/discover/movie", parameters: parameters).responseJSON { (response) in
            DispatchQueue.main.async {
                guard let data = response.data else { return }
                do {
                    let moviesDescription = try JSONDecoder().decode(DiscoveryResponse.self, from: data)
                    completionHandler(moviesDescription)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func downloadMovies(parameters: MovieParameters, completionHandler: @escaping CompletionHandler) {
        downloadMovies(parameters: parameters.toDictionary(), completionHandler: completionHandler)
    }
    
    //MARK: - Download movies genre from link
    
    func downloadGenres(completionHandler: @escaping GenresHandler) {
        Alamofire.request(Constants.baseUrlString + "/genre/movie/list?api_key=" + Constants.apiKey).responseJSON { (response) in
            
            DispatchQueue.main.async {
                guard let data = response.data else { return }
                do {
                    let moviesDesc = try JSONDecoder().decode(GenresModel.self, from: data)
                    completionHandler(moviesDesc)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //MARK: - Download movies trailers from link
    
    func downloadTrailer(movieId: Int, completionHandler: @escaping TrailersHandler) {
        print(Constants.baseUrlString + "/movie/\(movieId)" + "/videos?api_key=" + Constants.apiKey)
        Alamofire.request(Constants.baseUrlString + "/movie/\(movieId)" + "/videos?api_key=" + Constants.apiKey).responseJSON { (response) in
            DispatchQueue.main.async {
                guard let data = response.data else { return }
                do {
                    let movieTrailer = try JSONDecoder().decode(MovieVideoModel.self, from: data)
                    completionHandler(movieTrailer)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // MARK: - Download movies details from link
    
    func downloadDetails(moviesId: Int, completionHandler: @escaping DetailHandler) {
        Alamofire.request(Constants.baseUrlString + "/movie/\(moviesId)" + "?api_key=" + Constants.apiKey).responseJSON { (response) in
            DispatchQueue.main.async {
                guard let data = response.data else { return }
                do {
                    let movieDetails = try JSONDecoder().decode(MovieDetailModel.self, from: data)
                    completionHandler(movieDetails)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


    
/*
"https://www.imdb.com/title/tt1160368/"
*/

