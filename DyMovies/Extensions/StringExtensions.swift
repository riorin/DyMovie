//
//  StringExtensions.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

extension String {
    
    func date(with format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self) ?? Date(timeIntervalSince1970: 0)
    }
}
