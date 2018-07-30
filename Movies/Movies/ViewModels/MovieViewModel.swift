//
//  MovieViewModel.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation
import SVProgressHUD

enum MovieFetchState {
    case Empty
    case Error(message:String)
    case Completed
}

protocol MovieStateDelegate {
    func reloadMovieList(_ fetchState:MovieFetchState)
}

class MovieViewModel {
    
    var movies = [Movie]()
    var recentSearchList = [String]()
    var page = PageSession()
    var isFetching = false
    var movieRefreshDelegate:MovieStateDelegate?
    
    private var selectedQueryText = ""
    private let networkManager = NetworkManager()
    private let recentSearchManager = SearchManager()
    
    // Fetch Recent Searches stored in Userdefaults
    func fetchRecentSearchList() {
        self.recentSearchManager.fetchRecentSearchList { [weak self] searchList in
            guard let strongSelf = self else { return }
            strongSelf.recentSearchList.append(contentsOf: searchList)
        }
    }
    
    
    func numberOfRows(isSearch:Bool) -> Int {
        var count = 0
        if isSearch == true {
            count = self.recentSearchList.count
        }
        else {
            count = self.movies.count + (self.page.hasNextPage() ? 1 : 0)
        }
        return count
    }
    
    func searchMovies(query:String) {
        self.isFetching = true
        SVProgressHUD.show()
        self.networkManager.searchMoviesAPI(page: self.page.currentPage + 1, query: query) { (movieResponse, error) in
            SVProgressHUD.dismiss()
            self.isFetching = false
            var fetchStatus:MovieFetchState!
            if error != nil {
                let errorMessage = error ?? "Error: Unable to search movie results"
                fetchStatus = MovieFetchState.Error(message: errorMessage)
            }
            
            // Update Current Page for the search
            if let currentPage = movieResponse?.page {
                self.page.currentPage = currentPage
            }
            
            // Update Total Pages for the search
            if let totalPages = movieResponse?.numberOfPages {
                self.page.totalPage = totalPages
            }
            
            // Update Total Results
            if let totalResults = movieResponse?.numberOfResults {
                self.page.totalResults = totalResults
            }
            
            // Update Movies Array List
            if let moviesList = movieResponse?.movies,!moviesList.isEmpty {
                self.movies.append(contentsOf: moviesList)
                
                // Save successful queries to userdefaults
                if !self.recentSearchList.contains(query) {
                    self.recentSearchList.append(query)
                    self.recentSearchManager.saveSearch(text: query)
                }
            }
            
            fetchStatus = (self.movies.isEmpty) ? MovieFetchState.Empty :  MovieFetchState.Completed
            self.movieRefreshDelegate?.reloadMovieList(fetchStatus)
        }
    }
    
    
    /*
     - Save Recent search to userdefaults
     - clear movie arraylist if search is a new one
     -  fetch movies from api
     */
    
    func performSearch(_ query:String,isLoadMore:Bool = false) {
        self.selectedQueryText = query
        if !isLoadMore {
            self.clearMovies()
        }
        self.searchMovies(query: query)
    }
    
    func clearMovies() {
        self.page.resetPage()
        self.movies.removeAll()
    }
    
    func loadMorePage() {
        if !self.isFetching {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.performSearch(self.selectedQueryText, isLoadMore: true)
            }
        }
    }
}
