//
//  MoviePageTests.swift
//  MoviesTests
//
//  Created by karthikeyan on 7/30/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import XCTest
@testable import Movies

class MoviePageTests: XCTestCase {
    
    var page = PageSession()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPageHasNextPage() {
        self.page.currentPage = 1
        self.page.totalPage = 10
        
        XCTAssertTrue(self.page.hasNextPage(), "Has Next Page - should returns 'true'")
    }
    
    func testResetPaging() {
        self.page.resetPage()
        XCTAssertEqual(0,self.page.currentPage,"After Reset - Current Page should reset to 0")
    }
    
}
