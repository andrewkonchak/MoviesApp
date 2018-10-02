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
    
    typealias Movie = DiscoveryResponse.DiscoveryMovieModel
    
    private var isFetching = false
    
    private var movieModels: [Movie] = [] {
        didSet {
            self.collectionview.reloadData()
        }
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    

    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //peek and pop
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: collectionView)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieModels.count 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MainCollectionViewCell
        if let imagePath = movieModels[indexPath.row].poster_path, let imageUrl = URLUtils.imageUrl(withPath: imagePath) {
            let resource = ImageResource(downloadURL: imageUrl)
            cell.posterImage.kf.setImage(with: resource)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieModels.count - 3  {
            fetchNextPage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailView" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let detailVC = segue.destination as? DetailViewController
                detailVC?.movieModelDetails = movieModels[indexPath.row]
            }

        }
    }
}

private extension MainCollectionViewController {
    
    func refresh() {
        moviesApi.pageIndex = 1
        let parameters = SettingsManager.shared.getParameters()
        moviesApi.downloadMovies(parameters: parameters) { response in
            guard let results = response?.results, !results.isEmpty else {
                return
            }
            self.movieModels = results
        }
    }
    
    func fetchNextPage() {
        if isFetching {
            return
        }
        isFetching = true
        moviesApi.pageIndex += 1
        let parameters = SettingsManager.shared.getParameters()
        moviesApi.downloadMovies(parameters: parameters) { response in
            self.isFetching = false
            guard let results = response?.results, !results.isEmpty else {
                return
            }
            self.movieModels.append(contentsOf: results)
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

// MARK: - UIViewControllerPreviewingDelegate
extension MainCollectionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return nil }
        
        let movie = movieModels[indexPath.row]
        detailVC.movieModelDetails = movie
        // detailVC.preferredContentSize = CGSize(width: 0.0, height: 450)
        detailVC.mainViewController = self
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
            show(viewControllerToCommit, sender: self)
    }
}

struct URLUtils {
    
    static let baseImagePath = "https://image.tmdb.org/t/p/w500/"
    
    static func imageUrl(withPath path: String) -> URL? {
        let urlString = baseImagePath + path
        return URL(string: urlString)
    }
    
}

//extension URL {
//
//    static let basePath = "https://image.tmdb.org/t/p/w500/"
//
//    init?(imagePath: String) {
//        let urlString = URL.basePath + imagePath
//        if let url = URL(string: urlString) {
//            self = url
//        } else {
//            return nil
//        }
//    }
//
//}
