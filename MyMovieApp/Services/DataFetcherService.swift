//
//  DataParser.swift
//  MyMovieApp
//
//  Created by Kamil on 02/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import Foundation

protocol DataFetcherServiceType {
    func searchMovie(title: String, completion: @escaping ([Movie]?, Error?) -> Void)
    func fetchMovies(page: Int, completion: @escaping ([Movie]?, Error?) -> Void)
}

final class DataFetcherService: DataFetcherServiceType {

    private let mainUrl = Environment.serverURL.absoluteString
    
    func fetchMovies(page: Int, completion: @escaping ([Movie]?, Error?) -> Void) {
        let nowPlaying = Endpoint.nowPlaying.rawValue
        let stringURL = "\(mainUrl)/3\(nowPlaying)?language=en-US&page=\(page)"
        makeRequest(stringURL: stringURL) { completion($0, $1) }
    }
    
    func searchMovie(title: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        let search = Endpoint.search.rawValue
        let stringURL = "\(mainUrl)/3\(search)?query=\(title)"
        makeRequest(stringURL: stringURL) { completion($0, $1) }
    }
    
    private func makeRequest(stringURL: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = URL(string: stringURL) else { return }
        var request = URLRequest(url: url)
        let headers = [
          "accept": Environment.serverApplication,
          "Authorization": Environment.serverToken
        ]
        
        request.httpMethod = HTTPType.get.rawValue
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
