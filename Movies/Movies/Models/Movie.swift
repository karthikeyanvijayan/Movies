//
//  Movie.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation



struct MovieApiResponse {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let movies: [Movie]
}

extension MovieApiResponse: Decodable {
    
    private enum MovieApiResponseCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
        
    }
}


struct Movie {
    let id: Int
    let title: String
    
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    
    func formattedReleasedDate() -> String {
        guard let date = releaseDate else {
            return ""
        }
        return DateFormatter.formattedReleasedDate(stringDate: date, format: "MMM dd YYYY")
    }
    
}

extension Movie: Decodable {
    
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
        case overview
    }
    
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        id = try movieContainer.decode(Int.self, forKey: .id)
        posterPath = try movieContainer.decodeIfPresent(String.self, forKey: .posterPath)
        title = try movieContainer.decode(String.self, forKey: .title)
        releaseDate = try movieContainer.decodeIfPresent(String.self, forKey: .releaseDate)
        overview = try movieContainer.decodeIfPresent(String.self, forKey: .overview)
    }
}
