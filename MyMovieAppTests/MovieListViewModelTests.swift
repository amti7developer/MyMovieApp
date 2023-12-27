//
//  MyMovieAppTests.swift
//  MyMovieAppTests
//
//  Created by Kamil on 26/12/2023.
//  Copyright © 2023 Kamil Gacek. All rights reserved.
//

import XCTest
@testable import MyMovieApp


class MovieListViewModelTests: XCTestCase {
    
    let dataFetcherServiceMock = DataFetcherServiceMock()
    let moviewListViewModel: MovieListViewModelType? = nil
    let singleMovieArray: [Movie] = [Movie(adult: false, backdrop_path: "", genre_ids: [0], id: 0, original_language: "", original_title: "Some Movie", overview: "", popularity: 0, poster_path: "", release_date: "", title: "", video: false, vote_average: 0, vote_count: 0)]
    
    func testInitialization() {
        let dataFetcherServiceMock = DataFetcherServiceMock()
        
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        
        XCTAssertNotNil(movieListViewModel, "MovieListViewModel shall not be nil")
        XCTAssertTrue(movieListViewModel.dataFetcherService === dataFetcherServiceMock, "ServiceMock should be equal to the service mock we passed in")
    }
    
    func testUpdateEmptyMovieList() {
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        let emptyMovies: [Movie] = []
        
        movieListViewModel.updateMovieList(movies: emptyMovies)
        
        XCTAssertEqual(movieListViewModel.numberOfMovies(), 0, "MovieListViewModel number of movies should be 0")
    }
    
    func testNumberOfMovies() {
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        
        XCTAssertEqual(movieListViewModel.numberOfMovies(), 1, "MovieListViewModel number of movies should be 0")
    }
    
    func testGetMovies() {
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        
        XCTAssertEqual(movieListViewModel.getMovies()[0].original_title, "Some Movie")
        XCTAssertEqual(movieListViewModel.getMovies(), singleMovieArray)
    }
    
    func testMovieForIndex() {
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        let index = 0
        
        XCTAssertEqual(movieListViewModel.movieForIndex(index: index), singleMovieArray[index])
    }
    
    func testToggleLiked() {
        let movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        let index = 0
        
        let detailsViewModel = DetailsViewModel(movie: singleMovieArray[index])
        
        movieListViewModel.toggleLiked(liked: false, index: index)
        
        XCTAssertFalse(movieListViewModel.isMovieFavorite(index: index))
        
        XCTAssertEqual(detailsViewModel.isMovieFavorite(), movieListViewModel.isMovieFavorite(index: index))
        
        movieListViewModel.toggleLiked(liked: true, index: index)
        
        XCTAssertTrue(movieListViewModel.isMovieFavorite(index: index))
        
        XCTAssertEqual(detailsViewModel.isMovieFavorite(), movieListViewModel.isMovieFavorite(index: index))
    }
    
    func testFetchingMovies() {
        dataFetcherServiceMock.fetchMovies(page: 1) { movies, error in
            XCTAssertNil(error)
            XCTAssertNotNil(movies)
        }
    }
    
    func testSearchingMovies() {
        dataFetcherServiceMock.searchMovie(title: "Batman") { movies, error in
            XCTAssertNil(error)
            XCTAssertNotNil(movies)
        }
    }
}

// Mock DataFetcherService for testing
class DataFetcherServiceMock: DataFetcherServiceType {
    var moviesToReturn: [Movie]? = []

    func fetchMovies(page: Int, completion: @escaping ([Movie]?, Error?) -> Void) {
        completion(moviesToReturn, nil)
    }

    func searchMovie(title: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        completion(moviesToReturn, nil)
    }
}

// Mock delegate for testing
class MockDelegate: MovieListViewModelDelegate {
    let expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func viewModelReloadData(_ viewModel: MovieListViewModelType) {
        expectation.fulfill()
    }
}
