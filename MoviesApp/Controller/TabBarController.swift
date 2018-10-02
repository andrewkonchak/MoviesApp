//
//  TabBarController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 10/2/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarImage()
    }
    
}

extension UIViewController {
    
    func setNavigationBarImage(_ image: UIImage? = UIImage(named: "imdb")) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        navigationItem.titleView = imageView
    }
    
}
