//
//  MainCollectionViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/1/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit
import Alamofire


class MainCollectionViewController: UICollectionViewController {

    
    var moviesApi = MoviesApi()
    
    private var response: DiscoveryResponse?
    
    private var movieModels: [DiscoveryResponse.DiscoveryMovieModel] {
        return response?.results ?? []
    }
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesApi.downloadMovies(filters: [.year(2014)]) { response in
            self.response = response
            self.collectionview.reloadData()
        }
        
    }



    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieModels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MainCollectionViewCell {
            
            cell.titleLabel.text =  movieModels[indexPath.row].title
            cell.movieRating.text = String(movieModels[indexPath.row].vote_average)
            
            if let imageUrl = movieModels[indexPath.row].poster_path {
                Alamofire.request("https://image.tmdb.org/t/p/w500/" + imageUrl).responseJSON(completionHandler: { response in
                    guard let data = response.data else { return }
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.posterImage.image = image
                        }
                    }
                })
                
            }
            
            return cell
        }
        return UICollectionViewCell()
    }



}
