//
//  MainCollectionViewCell.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/1/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
