//
//  TableViewController.swift
//  MoviesApp
//
//  Created by Andrii Konchak on 7/31/18.
//  Copyright © 2018 Andrii Konchak. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

//    var movieModel = [MoviesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesApi.shared.downloadMovies(parameters: ["include_video" : true]) { (MoviesModel) in
            print("Lol")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.movieModel.count
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as! TableViewCell
        
//        cell.titleLabel.text = movieModel[indexPath.row].results.first?.title

        return cell
    }
}
