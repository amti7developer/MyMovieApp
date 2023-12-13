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
}

class MovieListViewModel: MovieListViewModelType {
    
    var movies: [Movie] = []
    var moviesAll: [Movie] = []
    weak var delegate: MovieListViewModelDelegate?
    
    func updateMovieList(movies: [Movie]) {
        self.movies = movies
    }
    
    func resetMovieList() {
        self.movies = moviesAll
    }
    
    func fetchMovies(page: Int) { // }, completion: () -> ()) {
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
}
