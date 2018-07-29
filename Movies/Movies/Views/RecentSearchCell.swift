//
//  RecentSearchCell.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import UIKit

class RecentSearchCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func updateDisplay(search:String) {
        self.lblTitle.text = search
    }
    
}
