//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import XCTest
@testable import Movies

class MoviesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func JSONData(fileName:String) -> Data? {
        let pathURL = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")
        guard let url = pathURL else {
            XCTFail("There is no such a file '\(fileName)")
            return nil
        }
        
        guard let data = try? Data.init(contentsOf: url) else {
            XCTFail("Cannot convert json file to data")
            return nil
        }
        return data
    }
    
    func testMovieAPIResponseModel() {
        
        guard let data = self.JSONData(fileName: "moviedata") else {
            return
        }
        
        do {
            let movieResponse = try JSONDecoder().decode(MovieApiResponse.self, from: data)
            XCTAssert((type(of: movieResponse) == MovieApiResponse.self), "Not a Movie API Response type")
            XCTAssertEqual(20, movieResponse.movies.count, "Movies Response current movies count is wrong. Should be '20'")
            XCTAssertEqual(1, movieResponse.page, "Movies Response current page is wrong. Should be '1'")
            XCTAssertEqual(6, movieResponse.numberOfPages, "Movies Response total pages is wrong. Should be '6'")
            XCTAssertEqual(109, movieResponse.numberOfResults, "Movies Response total movies count is wrong. Should be '109'")
        }
        catch {
            XCTFail("Movie API Responses didn't mapped. Missing parameters (non optinals)")
        }
        
    }
    
    func testMovieModel() {
        guard let data = self.JSONData(fileName: "movie") else {
            return;
        }
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            
            XCTAssert((type(of: movie) == Movie.self), "Not a movie type")
            XCTAssertEqual("Mission: Impossible - Fallout", movie.title, "Movie title is wrong. Should be 'Mission: Impossible - Fallout'")
            XCTAssertEqual(353081, movie.id, "Movie id is wrong. Should be '353081'")
            XCTAssertEqual("2018-07-25", movie.releaseDate, "Movie date is wrong. Should be '2018-07-25'")
        }
        catch {
            XCTFail("Movie didn't mapped. Missing parameters (non optinals)")
        }
    }
    
    
}
