//
//  DetailViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/21/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    let parameters = SettingsManager.shared.getParameters()
    
    var apiMovies = MoviesApi()
    var mainView = MainCollectionViewController()
    
    private var response: DiscoveryResponse?
    private var modelMovie: [DiscoveryResponse.DiscoveryMovieModel] {
        return response?.results ?? []
    }
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var moviesTitle: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        downloadElements()
        fullImage.layer.cornerRadius = 10
    }
    
    func downloadElements() {
        
        let parameters = SettingsManager.shared.getParameters()
        apiMovies.downloadMovies(parameters: parameters) { response in
            self.response = response
            //            self.mainView.collectionView.reloadData()
            self.moviesTitle.text = self.modelMovie.first?.title
            self.movieSummary.text = self.modelMovie.first?.overview
            self.releaseDate.text = self.modelMovie.first?.release_date
            
            let backdropURL = "https://image.tmdb.org/t/p/w500"
            if let backdropModel = self.modelMovie.first?.backdrop_path {
                let resource = ImageResource(downloadURL: URL(string: backdropURL + backdropModel)!, cacheKey: backdropURL + backdropModel)
                self.fullImage.kf.setImage(with: resource)
            }
        }
    }
}
