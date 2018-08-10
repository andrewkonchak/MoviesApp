//
//  SettingsTableViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 8/6/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var movieApi = MoviesApi()
    var sortParameters: [MovieSortParameter] = [.name(.ascending), .year(.ascending), .rating(.ascending)]
    
    private var response: GenresModel?
    private var movieGenre: [GenresModel.Genres] {
        return response?.genres ?? []
    }
    
    private var responsed: DiscoveryResponse?
    private var movieModels: [DiscoveryResponse.DiscoveryMovieModel] {
        return responsed?.results ?? []
    }
    
    private var filters: [MoviesFilter] = SettingsManager.shared.filters {
        didSet {
            SettingsManager.shared.setFilters(filters)
        }
    }
    
    var yearsTillNow : [String] {
        var years = [String]()
        for i in (1920..<2021).reversed() {
            years.append("\(i)")
        }
        return years
    }
    
    @IBOutlet weak var genrePickerOutlet: UIPickerView!
    @IBOutlet weak var sortByPickerOutlet: UIPickerView!
    @IBOutlet weak var yearPickerOutlet: UIPickerView!
    
    @IBAction func sortByOrder(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieApi.downloadGenres { (response) in
            self.response = response
            self.genrePickerOutlet.reloadAllComponents()
        }
        
        let parameters = SettingsManager.shared.getParameters()
        movieApi.downloadMovies(parameters: parameters) { responsed in
            self.responsed = responsed
            self.yearPickerOutlet.reloadAllComponents()
        }
        self.sortByPickerOutlet.reloadAllComponents()
    }
}

extension SettingsTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerOutlet {
            return movieGenre.count
        } else if pickerView == sortByPickerOutlet {
            return sortParameters.count
        } else if pickerView == yearPickerOutlet {
            return yearsTillNow.count
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerOutlet {
            return movieGenre[row].name
        } else if pickerView == sortByPickerOutlet {
            return sortParameters[row].name
        } else if pickerView == yearPickerOutlet {
            return yearsTillNow[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerOutlet {
           SettingsManager.shared.setFilters([MoviesFilter.genres(["\(movieGenre[row].id)"])])
        } else if pickerView == sortByPickerOutlet {
            SettingsManager.shared.setSortParameters(sortParameters[row])
        } else if pickerView == yearPickerOutlet {
            SettingsManager.shared.setFilters([MoviesFilter.year(Int(yearsTillNow[row]) ?? 0)])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == genrePickerOutlet {
        let titleData = movieGenre[row].name
        let pickerTitleFirst = NSAttributedString(string: titleData,
                                             attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 2.0)!,
                                                          NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9742920123, green: 0.9727308783, blue: 1, alpha: 1)])
        return pickerTitleFirst
            
        } else if pickerView == sortByPickerOutlet {
            let dataTitle = sortParameters[row].key
            let pickerTitleSecond = NSAttributedString(string: dataTitle,
                                                 attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 2.0)!,
                                                              NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9742920123, green: 0.9727308783, blue: 1, alpha: 1)])
            return pickerTitleSecond
            
        } else if pickerView == yearPickerOutlet {
            let dataTitle = yearsTillNow[row]
            let pickerTitleThird = NSAttributedString(string: dataTitle,
                                                 attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 2.0)!,
                                                              NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9742920123, green: 0.9727308783, blue: 1, alpha: 1)])
            return pickerTitleThird
        }
        return NSAttributedString.init(string: "")
   }
}
