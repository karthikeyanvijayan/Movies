//
//  SearchManager.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation

class SearchManager {
    
    let userDefaultsKey = "RecentSearch"
    
    let recentSearchLimit = 10
    
    // save the search query - we using userdefaults for persistence
    func saveSearch(text:String) {
        var searchList = [String]()
        if let searchCachedItems = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            searchList.append(contentsOf: searchCachedItems)
        }
        
        if !searchList.contains(text) {
            searchList.insert(text, at: 0)
        }
        
        // if search list greater than search limit - remove the last item
        if searchList.count > recentSearchLimit {
            searchList.removeLast()
        }
        
        self.saveArrayToUserDefaults(searchList)
        
    }
    
    func saveArrayToUserDefaults(_ searchList:[String]) {
        UserDefaults.standard.set(searchList, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    // Fetch Search items from Userdefaults if available
    func fetchRecentSearchList(completion:(_ items:[String]) -> ()) {
        if let searches = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            completion(searches)
        }
        completion([])
    }
    
    func clearRecentSearches() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    
}
