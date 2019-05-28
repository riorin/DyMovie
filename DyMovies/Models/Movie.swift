//
//  Movie.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation
import UIKit

struct Movie: Decodable {
    
    var voteCount: Int = 0
    var id: Int = 0
    var video: Bool = false
    var voteAverage: Double = 0.0
    var title: String = ""
    var popularity: Double = 0.0
    var posterPath: String = ""
    var originalLanguage: String = ""
    var originalTitle: String = ""
    var genreIds: [Int] = []
    var backdropPath: String = ""
    var adult: Bool = false
    var overview: String = ""
    var releaseDate: Date = Date(timeIntervalSince1970: 0)
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case video
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        video = try container.decodeIfPresent(Bool.self, forKey: .video) ?? false
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        releaseDate = dateString.date(with: "yyyy-MM-dd")
    }
    
    var posterUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
