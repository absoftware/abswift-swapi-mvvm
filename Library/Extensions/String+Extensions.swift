//
//  String+Extensions.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 01/10/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Filters
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
