//
//  DetailsViewModel.swift
//  GameOfThronesFactsApp
//
//  Created by Kamil on 28/09/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit

protocol DetailsViewModelType {
    var movie: Movie { get }
    
    func isMovieFavorite() -> Bool
    func toggleLiked()
}

class DetailsViewModel: DetailsViewModelType {
    
    private let defaults = UserDefaults.standard
    
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func isMovieFavorite() -> Bool {
        let movieID = movie.id ?? 0
        let isFav = defaults.bool(forKey: "\(movieID)")
        print("(*) IsFav?", isFav)
        return isFav
    }
    
    func toggleLiked() {
        let movieID = movie.id ?? 0
        
//        print("is?", !isMovieFavorite())
        defaults.set(!isMovieFavorite(), forKey: "\(movieID)")
//        print("(*) isFavorite: ", movieID)
    }
}