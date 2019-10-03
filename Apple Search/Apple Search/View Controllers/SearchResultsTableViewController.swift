//
//  SearchResultsTableViewController.swift
//  Apple Search
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.


import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    var musicSearchResults: [MusicSearchResult] = []
    var appSearchResults: [AppSearchResult] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        self.tableView.reloadData()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.searchBar.placeholder = "Search for a Song or Artist"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            self.searchBar.placeholder = "Search for an App"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
            !searchText.isEmpty
            else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            SearchController.getMusicItemsWith(searchText: searchText) { (results) in
                self.musicSearchResults = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchBar.text = ""
                    self.searchBar.resignFirstResponder()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            SearchController.getAppItemsWith(searchText: searchText) { (results) in
                self.appSearchResults = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchBar.text = ""
                    self.searchBar.resignFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if segmentedControl.selectedSegmentIndex == 0 {
            count = musicSearchResults.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            count = appSearchResults.count
        }
        
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? SearchTableViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let searchResultItem = musicSearchResults[indexPath.row]
            cell?.musicItem = searchResultItem
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let searchResultItem = appSearchResults[indexPath.row]
            cell?.appItem = searchResultItem
        }

        return cell ?? UITableViewCell()
    }
}


