//
//  Movie.swift
//  GameOfThronesFacts
//
//  Created by Kamil on 10/12/2023.
//  Copyright © 2023 Kamil Gacek. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    
    let dates: DateRange?
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
}

struct Movie: Codable, Equatable {
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}

struct DateRange: Codable {
    let maximum: String?
    let minimum: String?
}
