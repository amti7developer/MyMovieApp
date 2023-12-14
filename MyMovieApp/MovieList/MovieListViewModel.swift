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
    var movies: [Movie] { get }
    var moviesAll: [Movie] { get }
    
    func fetchMovies(page: Int) // , completion: () -> ())
    func updateMovieList(movies: [Movie])
    func resetMovieList()
    func reloadData()
    func toggleLiked(index: Int)
    func isMovieFavorite(index: Int) -> Bool
}

class MovieListViewModel: MovieListViewModelType {
    private let defaults = UserDefaults.standard
    
    var movies: [Movie] = []
    var moviesAll: [Movie] = []
    weak var delegate: MovieListViewModelDelegate?
    
    func updateMovieList(movies: [Movie]) {
        self.movies = movies
    }
    
    func resetMovieList() {
        self.movies = moviesAll
    }

    func toggleLiked(index: Int) {
        let movieID = movies[index].id ?? 0
        defaults.set(!isMovieFavorite(index: index), forKey: "\(movieID)")
        
        delegate?.viewModelReloadData(self)
    }
    
    func fetchMovies(page: Int) {
        DataFetcher.shared.fetchMovies(page: page) { [weak self] movies, error in
            guard let self = self, let movies = movies else { return }
                
            self.movies.append(contentsOf: movies)
            self.moviesAll.append(contentsOf: movies)
            self.delegate?.viewModelReloadData(self)
        }
    }
    
    func reloadData() {
        delegate?.viewModelReloadData(self)
    }
    
    func isMovieFavorite(index: Int) -> Bool {
        let movieID = movies[index].id ?? 0
        let isFav = defaults.bool(forKey: "\(movieID)")
        return isFav
    }
}
