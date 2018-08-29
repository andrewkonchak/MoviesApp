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
    
    private var movies: [DiscoveryResponse.DiscoveryMovieModel] = [] {
        didSet {
            self.collectionview.reloadData()
        }
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    private var lastPage = 1
    private var totalPages = 0
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFirstPage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFirstPage), name: .didUpdateSettings, object: nil)
    }
    
    
    @objc func fetchFirstPage() {
        lastPage = 1
        let parameters = SettingsManager.shared.getParameters()
        moviesApi.downloadMovies(parameters: parameters) { response in
            self.totalPages = response?.total_pages ?? 0
            self.movies = response?.results ?? []
        }
    }
    
    func fetchNextPage() {
        if isFetching {
            return
        }
        
        lastPage += 1
        if lastPage >= totalPages {
            return
        }
        isFetching = true
        let parameters = SettingsManager.shared.getParameters()
        moviesApi.downloadMovies(parameters: parameters, page: lastPage) { response in
            self.isFetching = false
            if let newMovies = response?.results {
                self.movies.append(contentsOf: newMovies)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MainCollectionViewCell {
            
            let urls = "https://image.tmdb.org/t/p/w500/"
            if let imageUrl = movies[indexPath.row].poster_path {
                let resource = ImageResource(downloadURL: URL(string: urls + imageUrl)!, cacheKey: urls + imageUrl)
                cell.posterImage.kf.setImage(with: resource)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= movies.count - 3 {
            fetchNextPage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailView" {
            let collectionCell = segue.destination as? DetailViewController
            let indexPaths = collectionView?.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            collectionCell?.movieModelDetails = movies[indexPath.row]
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

