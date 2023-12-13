//
//  CharacterListViewModel.swift
//  GameOfThronesFactsApp
//
//  Created by Kamil on 02/10/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import Foundation

protocol CharacterListViewModelDelegate: AnyObject {
    func viewModelReloadData(_ viewModel: CharacterListViewModelType)
}

protocol CharacterListViewModelType {
    var delegate: CharacterListViewModelDelegate? { get set }
    var movies: [Movie] { get }
    var moviesAll: [Movie] { get }
    
    func fetchCharaters()
    func updateMovieList(movies: [Movie])
    func resetMovieList()
    func reloadData()
}

class CharacterListViewModel: CharacterListViewModelType {
    
    var movies: [Movie] = []
    var moviesAll: [Movie] = []
    weak var delegate: CharacterListViewModelDelegate?
    
    func updateMovieList(movies: [Movie]) {
        self.movies = movies
    }
    
    func resetMovieList() {
        self.movies = moviesAll
    }
    
    func fetchCharaters() {
        DataFetcher.shared.fetchCharacters { [weak self] movies, error in
            guard let self = self, let movies = movies else { return }
            
            self.movies = movies
            self.moviesAll = movies
            self.delegate?.viewModelReloadData(self)
        }
    }
    
    func reloadData() {
        delegate?.viewModelReloadData(self)
    }
}
