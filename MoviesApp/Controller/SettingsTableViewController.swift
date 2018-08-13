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
    var buttonPressed = false
    var nameSortParameters = ["Name", "Year", "Rating","Popularity"]
    var sortParameters: [MovieSortParameter] = [.name(.descending),
                                                .year(.descending),
                                                .rating(.descending),
                                                .popularity(.descending)]
    
    private var response: GenresModel?
    private var movieGenre: [GenresModel.Genres] {
        return response?.genres ?? []
    }
    
    private var responsed: DiscoveryResponse?

    
    private var filters: [MoviesFilter] = SettingsManager.shared.filters {
        didSet {
            SettingsManager.shared.setFilters(filters)
        }
    }
    
    // Years to picker
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
    @IBOutlet weak var sortByOrderButtonOutlet: UIButton!
    
    @IBAction func sortByOrder(_ sender: UIButton) {
        if buttonPressed == false {
             sortByOrderButtonOutlet.setImage(UIImage(named: "double-arrow.png"), for: .normal)
            buttonPressed = true
            print("ascending")
        } else {
            sortByOrderButtonOutlet.setImage(UIImage(named: "flipImage.png"), for: .normal)
            buttonPressed = false
            print("descending")
        }
        
        saveSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieApi.downloadGenres { (response) in
            self.response = response
            self.genrePickerOutlet.reloadAllComponents()
        }
        
        let parameters = SettingsManager.shared.getParameters()
        readSettings()
    }
    
    func readSettings() {
        
    }
    
    func saveSettings() {
        
        let order: MovieSortParameter.Order = buttonPressed ? .ascending : .descending
        var sortParameter: MovieSortParameter!
        switch sortByPickerOutlet.selectedRow(inComponent: 0) {
        case 0:
            sortParameter = .name(order)
        case 1:
            sortParameter = .year(order)
        case 2:
            sortParameter = .rating(order)
        case 3:
            sortParameter = .popularity(order)
        default:
            break
        }
        SettingsManager.shared.setSortParameters(sortParameter)
        }
    }
}

extension SettingsTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerOutlet {
            return movieGenre.count + 1
        } else if pickerView == sortByPickerOutlet {
            return nameSortParameters.count
        } else if pickerView == yearPickerOutlet {
            return yearsTillNow.count
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerOutlet {
            if row == 0 {
                return "Any"
            }
            return movieGenre[row - 1].name
        } else if pickerView == sortByPickerOutlet {
            return nameSortParameters[row]
        } else if pickerView == yearPickerOutlet {
            return yearsTillNow[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == genrePickerOutlet {
//           SettingsManager.shared.setFilters([MoviesFilter.genres(["\(movieGenre[row].id)"])])
//        } else if pickerView == sortByPickerOutlet {
//            print(sortParameters[row].name)
//            SettingsManager.shared.setSortParameters(.year(.ascending))
//            SettingsManager.shared.setSortParameters(sortParameters[row].name)
//        } else if pickerView == yearPickerOutlet {
//            SettingsManager.shared.setFilters([MoviesFilter.year(Int(yearsTillNow[row]) ?? 0)])
//        }
        saveSettings()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let title = self.pickerView(pickerView, titleForRow: row, forComponent: component) {
            return NSAttributedString(string: title, attributes: [.foregroundColor: #colorLiteral(red: 0.9742920123, green: 0.9727308783, blue: 1, alpha: 1)])
        }
        return nil
   }
}
