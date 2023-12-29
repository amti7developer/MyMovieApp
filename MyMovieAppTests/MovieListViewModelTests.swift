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
    
    var dataFetcherServiceMock: DataFetcherServiceMock!
    var movieListViewModel: MovieListViewModelType!
    var singleMovieArray: [Movie]!
    var index: Int!
    var detailsViewModel: DetailsViewModelType!

    override func setUp() {
        super.setUp()
        index = 0
        dataFetcherServiceMock = DataFetcherServiceMock()
        movieListViewModel = MovieListViewModel(dataFetcherService: dataFetcherServiceMock)
        singleMovieArray = [Movie(adult: false, backdrop_path: "", genre_ids: [0], id: 0, original_language: "", original_title: "Some Movie", overview: "", popularity: 0, poster_path: "", release_date: "", title: "", video: false, vote_average: 0, vote_count: 0)]
        detailsViewModel = DetailsViewModel(movie: singleMovieArray[index])
    }
    
    override func tearDown() {
        super.tearDown()
        dataFetcherServiceMock = nil
        movieListViewModel = nil
        singleMovieArray = nil
        index = nil
        detailsViewModel = nil
    }
    
    func testInitialization() {
        XCTAssertNotNil(movieListViewModel, "MovieListViewModel shall not be nil")
        XCTAssertTrue(movieListViewModel.dataFetcherService === dataFetcherServiceMock, "ServiceMock should be equal to the service mock we passed in")
    }
    
    func testUpdateEmptyMovieList() {
        let emptyMovies: [Movie] = []
        movieListViewModel.updateMovieList(movies: emptyMovies)
        
        XCTAssertEqual(movieListViewModel.numberOfMovies(), 0, "MovieListViewModel number of movies should be 0")
    }
    
    func testNumberOfMovies() {
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        
        XCTAssertEqual(movieListViewModel.numberOfMovies(), 1, "MovieListViewModel number of movies should be 0")
    }
    
    func testGetMovies() {
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        
        XCTAssertEqual(movieListViewModel.getMovies()[0].original_title, singleMovieArray.first?.original_title, "MovieListViewModel and singleMovieArray first element should have same movie original title")
        XCTAssertEqual(movieListViewModel.getMovies(), singleMovieArray, "movieListVIewModel movies array should be the same as singleMovieArray")
    }
    
    func testMovieForIndex() {
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        let index = 0
        
        XCTAssertEqual(movieListViewModel.movieForIndex(index: index), singleMovieArray[index], "movieFromIndex method from movieListViewModel should be the same as singleMovieArray[index] ")
    }
    
    func testToggleLikedTrue() {
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        movieListViewModel.toggleLiked(liked: true, index: index)
        
        XCTAssertTrue(movieListViewModel.isMovieFavorite(index: index), "Movie Favorouite should be true")
        XCTAssertEqual(detailsViewModel.isMovieFavorite(), movieListViewModel.isMovieFavorite(index: index), "detailsViewModel and movieListViewModel should have equal boolean in terms of isMovieFavorite")
    }
    
    func testToggleLikedFalse() {
        movieListViewModel.updateMovieList(movies: singleMovieArray)
        movieListViewModel.toggleLiked(liked: false, index: index)
        
        XCTAssertFalse(movieListViewModel.isMovieFavorite(index: index), "Movie Favorite should be false")
        XCTAssertEqual(detailsViewModel.isMovieFavorite(), movieListViewModel.isMovieFavorite(index: index), "detailsViewModel and movieListViewModel should have equal boolean in terms of isMovieFavorite")
    }
    
    func testFetchingMovies() {
        dataFetcherServiceMock.fetchMovies(page: 1) { movies, error in
            XCTAssertNil(error, "Error in method fetchMovies should be nil")
            XCTAssertNotNil(movies, "Movies in method fetchMovies should not be nil")
        }
    }
    
    func testSearchingMovies() {
        dataFetcherServiceMock.searchMovie(title: "Batman") { movies, error in
            XCTAssertNil(error, "Error in method searchMovie should be nil")
            XCTAssertNotNil(movies, "Movies in method searchMovie should not be nil")
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
