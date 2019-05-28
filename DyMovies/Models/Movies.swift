//
//  Movies.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

struct Movies: Decodable {
    
    var page: Int = 0
    var totalResults: Int = 0
    var totalPages: Int = 0
    var results: [Movie] = []
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        results = try container.decodeIfPresent([Movie].self, forKey: .results) ?? []
    }
}
