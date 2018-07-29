//
//  DateFormatter+MovieDate.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation


extension DateFormatter {
    
    static let customDateFormatter = DateFormatter()
    
    open static func formattedReleasedDate(stringDate:String,format:String) -> String {
        var stringReleasedDate = ""
        customDateFormatter.dateFormat = "yyyy-MM-dd"
        if let validDate = customDateFormatter.date(from: stringDate) {
            customDateFormatter.dateFormat = format
            stringReleasedDate = customDateFormatter.string(from: validDate)
        }
        return stringReleasedDate
    }
    
}

