//
//  DataParser.swift
//  MyMovieApp
//
//  Created by Kamil on 02/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import Foundation

class DataFetcher {
    
    static let shared = DataFetcher()
    private init() {}

    private let mainUrl = Environment.serverURL.absoluteString

    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> Void) {
        let stringURL = "\(mainUrl)/3/movie/now_playing?language=en-US&page=1"
        guard let url = URL(string: stringURL) else { return }
        var request = URLRequest(url: url)
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzN2Q1OGIzZjc5NmI3Njg0MTVkMWViZDFjNTA5NzljZSIsInN1YiI6IjY1NzQ0YzExYmJlMWRkMDExYjhmNzNmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uYbehKEuI4Bb_2GCayisTwSc50x-iFczydYpDoizdSA  "
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
                
        getFetcher(request: request) { completion($0, $1) }
    }

    private func getFetcher(request: URLRequest, completion: @escaping ([Movie]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, FetcherError.wrongData)
                return
            }

            do {
                let model = try JSONDecoder().decode(MovieResponse.self, from: data)
                
                completion(model.results, nil)
            } catch let err {
                completion(nil, err)
            }
        }.resume()
    }
}


enum FetcherError: Error {
    case wrongURL
    case wrongData
}
