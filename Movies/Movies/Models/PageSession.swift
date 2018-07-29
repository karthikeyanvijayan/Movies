//
//  PageSession.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation

struct PageSession {
    
    var currentPage = 0
    var totalPage = 0
    var totalResults = 0
    
    mutating func resetPage() {
        self.currentPage = 0
        self.totalPage = 1
    }
    
    func hasNextPage() -> Bool {
        return self.currentPage < self.totalPage
    }
    
}
