//
//  DetailsViewModelTests.swift
//  MyMovieAppTests
//
//  Created by Kamil on 26/12/2023.
//  Copyright © 2023 Kamil Gacek. All rights reserved.
//

import XCTest
@testable import MyMovieApp

final class DetailsViewModelTests: XCTestCase {
    
    let movie = Movie(adult: true, backdrop_path: "", genre_ids: [0], id: 0, original_language: "", original_title: "Some Movie", overview: "", popularity: 0, poster_path: "", release_date: "", title: "Some Movie", video: false, vote_average: 0, vote_count: 0)
    
    func testRoundPiNumber() {
        let viewModel = DetailsViewModel(movie: movie)
        
        let notRoundedValue: Double = 3.141592653589793238
        let roundedValue: Double = 3.1
        
        XCTAssertEqual(viewModel.roundNumber(value: notRoundedValue), roundedValue)
    }
    
    func testNotFavorite() {
        let viewModel = DetailsViewModel(movie: movie)
        
        viewModel.toggleLiked(liked: false)
        
        XCTAssertFalse(viewModel.isMovieFavorite())
    }
    
    func testFavorite() {
        let viewModel = DetailsViewModel(movie: movie)
        
        viewModel.toggleLiked(liked: true)
        
        XCTAssertTrue(viewModel.isMovieFavorite())
    }
    
}
