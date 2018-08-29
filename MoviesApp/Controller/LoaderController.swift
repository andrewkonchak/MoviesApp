//
//  LoaderController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/29/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class LoaderController: NSObject {

    static let sharedInstance = LoaderController()
    private let activityIndicator = UIActivityIndicatorView()
    
    //MARK: - setup loader
    private func setupLoader() {
        removeLoader()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    //MARK: - show loader
    func showLoader() {
        setupLoader()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let holdingView = appDel.window!.rootViewController!.view!
        
        DispatchQueue.main.async {
            self.activityIndicator.center = holdingView.center
            self.activityIndicator.startAnimating()
            holdingView.addSubview(self.activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
