//
//  SwapiGender.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

/// Value of enum is string which comes from JSON directly.
enum SwapiGender: String, Codable {
    
    case male = "male"
    case female = "female"
    case unknown = "unknown"
    case notApplicable = "n/a"
}
