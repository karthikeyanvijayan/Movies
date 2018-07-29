//
//  NetworkManager.swift
//  Movies
//
//  Created by karthikeyan on 7/29/18.
//  Copyright © 2018 karthikeyan. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

class NetworkManager {
    
    private let movieAPIKey = "bc2a2ade2791284784ca89ce9fce038f"
    private let movieAPI_BaseURL = "http://api.themoviedb.org/3/"
    //   http://api.themoviedb.org/3/search/movie?api_key=bc2a2ade2791284784ca89ce9fce038f&query=bourne&page=1
    
    fileprivate func buildAPIUrl(page:Int,query:String) -> String {
        return movieAPI_BaseURL + "search/movie?" + "api_key=\(movieAPIKey)" + "&query=\(query)" + "&page=\(page)"
    }
    
    func searchMoviesAPI(page:Int,query:String,
                         completion: @escaping (_ movieResponse: MovieApiResponse?,_ error: String?)->()) {
        
        let searchURLString = self.buildAPIUrl(page: page, query: query)
        let searchAPI = URL(string: searchURLString)!
        print(searchURLString)
        
        let searchTask = URLSession.shared.dataTask(with: searchAPI) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: responseData)
                        completion(apiResponse,nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        
        searchTask.resume()
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}
