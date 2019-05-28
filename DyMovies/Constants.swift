//
//  Constants.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

let kTmdbApiKeyV3 = "62fe533a4718f5f8257cae0101d56959"

enum MovieSortBy: String {
    case popularityAsc = "popularity.asc"
    case popularityDesc = "popularity.desc"
    case releaseDateAsc = "release_date.asc"
    case releaseDateDesc = "release_date.desc"
    case originalTitleAsc = "original_title.asc"
    case originalTitleDesc = "original_title.desc"
    case vote_averageAsc = "vote_average.asc"
    case vote_averageDesc = "vote_average.desc"
}

struct Genre {
    var id: Int
    var name: String
}
