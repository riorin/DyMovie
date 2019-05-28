//
//  ErrorResponse.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    
    var statusCode: Int = 0
    var statusMessage: String = ""
    var success: Bool = false
    var errors: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
        case errors
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        statusMessage = try container.decodeIfPresent(String.self, forKey: .statusMessage) ?? ""
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        errors = try container.decodeIfPresent([String].self, forKey: .errors) ?? []
    }
    
    var errorMessage: String {
        
        if errors.count > 0 {
            return errors.map({ $0 }).joined(separator: "\n")
        }
        else {
            return "[\(statusCode)] \(statusMessage)"
        }
    }
}
