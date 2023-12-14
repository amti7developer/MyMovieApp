//
//  DetailsViewModel.swift
//  MyMovieApp
//
//  Created by Kamil on 28/09/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit

protocol DetailsViewModelType {
    var movie: Movie { get }
    
    func isMovieFavorite() -> Bool
    func toggleLiked()
    func roundNumber(value: Double) -> Double
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
        return isFav
    }
    
    func roundNumber(value: Double) -> Double {
        Double(round(10 * value) / 10)
    }
    
    func toggleLiked() {
        let movieID = movie.id ?? 0
        defaults.set(!isMovieFavorite(), forKey: "\(movieID)")
    }
}
