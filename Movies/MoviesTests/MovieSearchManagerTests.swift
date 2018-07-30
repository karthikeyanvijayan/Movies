//
//  MovieSearchManagerTests.swift
//  MoviesTests
//
//  Created by karthikeyan on 7/30/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import XCTest
@testable import Movies

class MovieSearchManagerTests: XCTestCase {
    
    let searchManager = SearchManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClearSearches() {
        self.searchManager.clearRecentSearches()
        self.searchManager.fetchRecentSearchList { (searchList) in
            XCTAssertEqual(0, searchList.count, "Search List should be empty - '0' count")
        }
    }
    
    func testSaveRecentSearchItem() {
        let query = "Jason Bourne"
        self.searchManager.saveSearch(text: query)
        self.searchManager.fetchRecentSearchList { (searchList) in
            print(searchList)
            if let item = searchList.first {
                  print(item)
                XCTAssertTrue(item == "Jason Bourne","Search item should contain the search term 'Jason Bournes'")
            }
        }
    }
    
   
    
}
