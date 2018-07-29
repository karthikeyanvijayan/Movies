//
//  SearchMoviesViewController.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController,MovieStateDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let movieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cells
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        // Register Cells
        self.tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)
        self.tableView.register(RecentSearchCell.nib, forCellReuseIdentifier: RecentSearchCell.identifier)
        
        self.movieViewModel.movieRefreshDelegate = self
        
        // Fetch Recent Search List from UserDefaults
        self.movieViewModel.fetchRecentSearchList()
    }
    
    // Reload Tableview when view model data updated
    func reloadMovieList(_ fetchState: MovieFetchState) {
        self.updateSearchResult(fetchState)
    }
    
}

//#MARK: UITableview Datasource
extension SearchMoviesViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieViewModel.numberOfRows(isSearch: self.searchBar.isFirstResponder)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // show Recent Searches Cell
        if self.searchBar.isFirstResponder {
            return self.recentSearchCell(indexpath: indexPath)
        }
        else {
            if self.movieViewModel.movies.count > 0 {
                if indexPath.row == self.movieViewModel.movies.count {
                    return self.loadingCell()
                }
                return self.movieCell(indexpath: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func movieCell(indexpath:IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexpath) as! MovieCell
        let movie = self.movieViewModel.movies[indexpath.row]
        cell.updateDisplay(movie: movie)
        return cell
    }
    
    func loadingCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellLoading")
        cell.textLabel?.text = "Loading..."
        cell.textLabel?.textAlignment = .center
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        cell.accessoryView = activity
        activity.startAnimating()
        return cell
    }
    
    func recentSearchCell(indexpath:IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexpath) as! RecentSearchCell
        let searchItem = self.movieViewModel.recentSearchList[indexpath.row]
        cell.updateDisplay(search: searchItem)
        return cell
    }
    
}

//#MARK: UITableview Delegate
extension SearchMoviesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if self.searchBar.isFirstResponder {
            title = "Recent Searches"
        }
        else {
            if !self.movieViewModel.movies.isEmpty {
                title = "\(self.movieViewModel.page.totalResults) Results Found"
            }
        }
        return title
    }
    
    func isLoadingIndexpath(_ indexPath:IndexPath) -> Bool  {
        guard self.movieViewModel.page.hasNextPage() else  { return false }
        return (!self.movieViewModel.movies.isEmpty && (indexPath.row == self.movieViewModel.movies.count))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.searchBar.isFirstResponder {
            if (self.isLoadingIndexpath(indexPath) && cell.reuseIdentifier == "CellLoading"){
                self.movieViewModel.loadMorePage()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchBar.isFirstResponder {
            let searchText = self.movieViewModel.recentSearchList[indexPath.row]
            self.updateSearchUI()
            self.movieViewModel.performSearch(searchText)
        }
    }
    
}

extension SearchMoviesViewController:UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.canShowCancelButton(status: true)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchAction()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.updateSearchUI()
    }
    
    func searchAction() {
        self.updateSearchUI()
        if let searchText = self.searchBar.text, !searchText.isEmpty {
            self.searchBar.text = ""
            self.movieViewModel.performSearch(searchText)
        }
    }
    
    func canShowCancelButton(status: Bool) {
        self.searchBar.setShowsCancelButton(status, animated: true)
    }
    
    func updateSearchUI() {
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
        self.canShowCancelButton(status: false)
    }
    
    func updateSearchResult(_ status:MovieFetchState) {
        DispatchQueue.main.async {
            switch status {
            case .Error(let message) :
                self.showAlert(message)
            case .Empty:
                self.showAlert("No Results Found")
            case .Completed:
                break;
            }
            self.tableView.reloadData()
        }
    }
}
