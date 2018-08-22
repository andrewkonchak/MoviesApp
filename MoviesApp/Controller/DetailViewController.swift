//
//  DetailViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/21/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

class DetailViewController: UIViewController {
    
    let parameters = SettingsManager.shared.getParameters()
    
    var apiMovies = MoviesApi()
    var mainView = MainCollectionViewController()
    var movieModelDetails: DiscoveryResponse.DiscoveryMovieModel?
    private var response: MovieVideoModel?
    private var movieTrailers: MovieVideoModel.Results?
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var moviesTitle: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var videoWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        apiMovies.downloadTrailer(movieId: movieModelDetails?.id ?? 0) { response in
            self.response = response
            self.getVideo(videoCode: response?.results.first?.key ?? "")
        }
        downloadElements()
    }
    
    func getVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoWebView.load(URLRequest(url: url!))
    }
    
    func downloadElements() {
        
            self.moviesTitle.text = self.movieModelDetails?.title
            self.movieSummary.text = self.movieModelDetails?.overview
            self.releaseDate.text = self.movieModelDetails?.release_date
            
            let backdropURL = "https://image.tmdb.org/t/p/w500"
            if let backdropModel = self.movieModelDetails?.backdrop_path {
                let resource = ImageResource(downloadURL: URL(string: backdropURL + backdropModel)!, cacheKey: backdropURL + backdropModel)
                self.fullImage.kf.setImage(with: resource)
            }
        }
    }
