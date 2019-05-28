//
//  DateExtensions.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 26/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import Foundation

extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func string(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
