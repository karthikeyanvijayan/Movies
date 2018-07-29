//
//  MovieCell.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // Update UI for Movie 
    func updateDisplay(movie:Movie) {
        
        self.lblTitle.text = movie.title
        self.lblOverview.text = movie.overview
        
        self.lblReleaseDate.text = movie.formattedReleasedDate()
        
        if let movieURLString = movie.posterPath,!movieURLString.isEmpty {
            let posterURL = URL.getMoviePosterURL(fromPath: movieURLString, size: .w92)
            self.imagePoster.kf.setImage(with: posterURL,placeholder:#imageLiteral(resourceName: "ic_movie"))
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

