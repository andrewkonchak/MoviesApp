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
import SafariServices

class DetailViewController: UIViewController {
    
    let parameters = SettingsManager.shared.getParameters()
    
    var apiMovies = MoviesApi()
    var movieModel: DiscoveryResponse.DiscoveryMovieModel?
    weak var mainViewController: MainCollectionViewController?

    private var response: MovieVideoModel?
    private var movieTrailers: MovieVideoModel.Results?
    private var movieDetails: MovieDetailModel?
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var moviesTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var country: UILabel!
    

    @IBAction func WEBButton(_ sender: Any) {
        showHomepage()
    }
    @IBAction func IMDBButton(_ sender: Any) {
        showTutorial(imdbCode: movieDetails?.imdb_id ?? "")
    }
    // peek and pop
    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share movie info", style: .default) { (action, viewController) -> Void in
//            let activityVC = UIActivityViewController(activityItems: ["Lol"], applicationActivities: nil)
//            activityVC.popoverPresentationController?.sourceView = self.view
//            self.present(activityVC, animated: true, completion: nil)
        }
        
        let deleteAction = UIPreviewAction(title: "Cancel", style: .destructive) { (action, viewController) -> Void in
            print("exit")
        }
        return [shareAction, deleteAction]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarImage()
        apiMovies.downloadDetails(moviesId: movieModel?.id ?? 0) { movieDetails in
            self.movieDetails = movieDetails
            self.downloadElements()
            
            self.imdbButton.layer.cornerRadius = 10
            self.webButton.layer.cornerRadius = 10
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        apiMovies.downloadTrailer(movieId: movieModel?.id ?? 0) { response in
            self.response = response
            self.getVideo(videoCode: response?.results.first?.key ?? "")
        }
        releaseDateFormatter()
    }
    
    func getVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoWebView.load(URLRequest(url: url!))
    }
    
    // IMDBButton
    func showTutorial(imdbCode: String) {
        if let url = URL(string: "https://www.imdb.com/title/\(imdbCode)/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    // WebButton
    func showHomepage() {
        if movieDetails?.homepage == nil {
        webButton.isEnabled = false
        webButton.alpha = 0.5
            let alert = UIAlertController(title: "OOPS!", message: "This web page is not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let homepage = movieDetails?.homepage, let url = URL(string: homepage) {
                let confog = SFSafariViewController.Configuration()
                confog.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: url, configuration: confog)
                present(vc, animated: true)
            }
        }
    }
    
    // flag
    private func flagFunc(country:String) -> String {
        
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            let inc = Int(i)
            let code = Unicode.Scalar(base + inc)
            usv.append(code!)
        }
        return String(usv)
    }
    
    func downloadElements() {
        
        guard let details = movieDetails else { return }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        self.moviesTitle.text = details.title
        self.movieRating.text = forTrailingZero(temp: details.vote_average ?? 0.0)
        self.movieSummary.text = details.overview
        self.genre.text = details.genres.compactMap { $0.name }.joined(separator: ", ")
        self.voteCount.text = String(details.vote_count ?? 0)
        self.country.text = flagFunc(country: details.production_countries.compactMap {$0.iso_3166_1}.joined(separator: ", "))
        
        if let runtime = details.runtime {
            let hours = runtime / 60
            let minutes = runtime % 60
            self.runtime.text = "\(hours) h \(minutes) m"
        }

        if let revenue = details.revenue, let revenueString = numberFormatter.string(from: NSNumber(value: revenue)) {
            self.revenue.text = "$ \(revenueString)"
        }
        
        if let budget = details.budget, let budgetString = numberFormatter.string(from: NSNumber(value: budget)) {
            self.budget.text = "$ \(budgetString)"
        }

        let backdropURL = "https://image.tmdb.org/t/p/w500"
            if let backdropModel = self.movieModel?.backdrop_path {
                let resource = ImageResource(downloadURL: URL(string: backdropURL + backdropModel)!, cacheKey: backdropURL + backdropModel)
                self.fullImage.kf.setImage(with: resource)
            }
        }
    
    // Rounding Vote Rating
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    // Release date formatter
    func releaseDateFormatter() {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: movieModel?.release_date ?? "" ){
            self.movieReleaseDate.text = dateFormatterPrint.string(from: date)
        }
        else {
            print("There was an error decoding the string")
        }
    }
}
