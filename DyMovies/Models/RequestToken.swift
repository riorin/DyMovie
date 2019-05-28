//
//  RequestToken.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

struct RequestToken: Decodable {
    
    var success: Bool = false
    var expiresAt: Date = Date(timeIntervalSince1970: 0)
    var requestToken: String = ""
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        requestToken = try container.decodeIfPresent(String.self, forKey: .requestToken) ?? ""
        let dateString = try container.decodeIfPresent(String.self, forKey: .expiresAt) ?? ""
        expiresAt = dateString.date(with: "yyyy-MM-dd HH:mm:ss Z")
    }
}
