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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parameters = SettingsManager.shared.getParameters()
        moviesApi.downloadMovies(parameters: parameters) { response in
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "openDetailView" {
                let cell = sender as? MainCollectionViewCell
                let detailVC = segue.destination as! DetailViewController
                detailVC.imageToPresent = cell?.imageView.image
                
            }
        }
    }
}


// MARK: - Poster image custom position to all screen

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

