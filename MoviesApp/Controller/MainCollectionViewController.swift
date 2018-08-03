//
//  MainCollectionViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/1/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit
import Kingfisher


class MainCollectionViewController: UICollectionViewController {

    var moviesApi = MoviesApi()
    
    private var response: DiscoveryResponse?
    private var movieModels: [DiscoveryResponse.DiscoveryMovieModel] {
        return response?.results ?? []
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filter: [MoviesFilter] = [
            .year(2018),
//            .sortBy(field: .voteCount, order: .descending)
        ]

        
        moviesApi.downloadMovies(filters: filter) { response in
            
            self.response = response
            self.collectionview.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MainCollectionViewCell {
            
            let urls = "https://image.tmdb.org/t/p/w500/"
            if let imageUrl = movieModels[indexPath.row].poster_path {
                let resource = ImageResource(downloadURL: URL(string: urls + imageUrl)!, cacheKey: urls + imageUrl)
                cell.posterImage.kf.setImage(with: resource)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let columnCount: CGFloat = 2
            let spacing: CGFloat = 10
            let ratio: CGFloat = 41/27
        
        let allSpaces = (columnCount + 1) * spacing
        let allCells = collectionView.bounds.width - allSpaces
        
        let width = allCells / columnCount
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
}

