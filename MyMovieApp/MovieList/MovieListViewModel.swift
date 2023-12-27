//
//  MovieListViewModel.swift
//  MyMovieApp
//
//  Created by Kamil on 02/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func viewModelReloadData(_ viewModel: MovieListViewModelType)
}

protocol MovieListViewModelType {
    var delegate: MovieListViewModelDelegate? { get set }
    var dataFetcherService: DataFetcherServiceType { get }

    func fetchMovies(page: Int)
    func searchMovies(movie: String)
    func updateMovieList(movies: [Movie])
    func resetMovieList()
    func reloadData()
    func toggleLiked(liked: Bool, index: Int)
    func isMovieFavorite(index: Int) -> Bool
    func getMovies() -> [Movie]
    func numberOfMovies() -> Int
    func movieForIndex(index: Int) -> Movie
}

class MovieListViewModel: MovieListViewModelType {
    
    weak var delegate: MovieListViewModelDelegate?
    let dataFetcherService: DataFetcherServiceType

    private let defaults = UserDefaults.standard
    
    private var movies: [Movie] = []
    private var moviesAll: [Movie] = []
    
    init(dataFetcherService: DataFetcherServiceType) {
        self.dataFetcherService = dataFetcherService
    }
    
    func updateMovieList(movies: [Movie]) {
        self.movies = movies
    }
    
    func resetMovieList() {
        self.movies = moviesAll
    }

    func getMovies() -> [Movie] {
        movies
    }
    
    func numberOfMovies() -> Int {
        movies.count
    }
    
    func movieForIndex(index: Int) -> Movie {
        return movies[index]
    }
    
    func fetchMovies(page: Int) {
        dataFetcherService.fetchMovies(page: page) { [weak self] movies, error in
            guard let self = self, let movies = movies else { return }
                
            self.movies.append(contentsOf: movies)
            self.moviesAll.append(contentsOf: movies)
            self.delegate?.viewModelReloadData(self)
        }
    }
    
    func searchMovies(movie: String) {
        dataFetcherService.searchMovie(title: movie) { [weak self] movies, error in
            guard let self = self, let movies = movies else { return }
            
            self.movies = movies
            self.delegate?.viewModelReloadData(self)
        }
    }

    func reloadData() {
        delegate?.viewModelReloadData(self)
    }
    
    func toggleLiked(liked: Bool, index: Int) {
        let movieID = movies[index].id ?? 0
        defaults.set(liked, forKey: "\(movieID)")
        delegate?.viewModelReloadData(self)
    }
    
    func isMovieFavorite(index: Int) -> Bool {
        let movieID = movies[index].id ?? 0
        let isFav = defaults.bool(forKey: "\(movieID)")
        return isFav
    }
}
