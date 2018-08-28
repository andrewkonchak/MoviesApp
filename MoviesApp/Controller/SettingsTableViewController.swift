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
    var nameSortParameters = ["Name",
                              "Year",
                              "Rating",
                              "Popularity"]
    
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
        for i in (1920..<2019).reversed() {
            years.append("\(i)")
        }
        return years
    }
    
    @IBOutlet weak var yearPickerOutlet: UIPickerView!
    @IBOutlet weak var genrePickerOutlet: UIPickerView!
    @IBOutlet weak var sortByPickerOutlet: UIPickerView!
    @IBOutlet weak var sortByOrderButtonOutlet: UIButton!
    
    @IBAction func resetAllButton(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "year")
        userDefaults.removeObject(forKey: "sortBy")
        userDefaults.removeObject(forKey: "genre")
    }
    
    @IBAction func sortByOrder(_ sender: UIButton) {
        
        if buttonPressed == false {
             sortByOrderButtonOutlet.setImage(UIImage(named: "asc.png"), for: .normal)
            buttonPressed = true
            print("ascending")
        } else {
            sortByOrderButtonOutlet.setImage(UIImage(named: "desc.png"), for: .normal)
            buttonPressed = false
            print("descending")
        }
        
        UserDefaults.standard.set(buttonPressed, forKey: "buttonPressed")
        saveSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.bool(forKey: "buttonPressed")
        
        movieApi.downloadGenres { (response) in
            self.response = response
            self.genrePickerOutlet.reloadAllComponents()
        }
        
        readSettings()
        //let parameters = SettingsManager.shared.getParameters()
    }
    
    func readSettings() {
        
        let rowSortBy = UserDefaults.standard.integer(forKey: "sortBy")
        sortByPickerOutlet.selectRow(rowSortBy, inComponent: 0, animated: false)
        
        let rowYear = UserDefaults.standard.integer(forKey: "year")
        yearPickerOutlet.selectRow(rowYear, inComponent: 0, animated: false)
        
        let rowGenre = UserDefaults.standard.integer(forKey: "genre")
        genrePickerOutlet.selectRow(rowGenre, inComponent: 0, animated: false)
    }
    
    func saveSettings() {
       
        // Sort
        let order: MovieSortParameter.Order = buttonPressed ? .ascending : .descending
        var sortParameter: MovieSortParameter!
        var filterParameters = [MoviesFilter]()
        
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
        
        // Filter
        let selectedGenreIndex = genrePickerOutlet.selectedRow(inComponent: 0)
        let selectedYearIndex = yearPickerOutlet.selectedRow(inComponent: 0)
        
        if selectedGenreIndex > 0 {
            filterParameters.append(MoviesFilter.genres(["\(movieGenre[selectedGenreIndex - 1].id)"]))
        }
        
        if selectedYearIndex > 0 {
            filterParameters.append(MoviesFilter.year(Int(yearsTillNow[selectedYearIndex - 1]) ?? 0))
        }
        
        SettingsManager.shared.setFilters(filterParameters)
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
            return yearsTillNow.count + 1
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerOutlet {
            if row == 0 {
                return "Any genre"
            }
            return movieGenre[row - 1].name
        } else if pickerView == sortByPickerOutlet {
            return nameSortParameters[row]
        } else if pickerView == yearPickerOutlet {
            if row == 0 {
                return "Any year"
            }
            return yearsTillNow[row - 1]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sortByPickerOutlet {
            UserDefaults.standard.set(row, forKey: "sortBy")
        } else if pickerView == yearPickerOutlet {
            if row == 0 {
                UserDefaults.standard.removeObject(forKey: "year")
            } else {
                UserDefaults.standard.set(row, forKey: "year")
            }
        } else if pickerView == genrePickerOutlet {
            if row == 0 {
                UserDefaults.standard.removeObject(forKey: "genre")
            } else {
             UserDefaults.standard.set(row, forKey: "genre")
            }
        }
        saveSettings()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let title = self.pickerView(pickerView, titleForRow: row, forComponent: component) {
            return NSAttributedString(string: title, attributes: [.foregroundColor: #colorLiteral(red: 0.9742920123, green: 0.9727308783, blue: 1, alpha: 1)])
        }
        return nil
   }
}
