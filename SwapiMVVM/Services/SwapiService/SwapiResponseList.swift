//
//  SwapiResponseList.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

/// Response for list of items.
/// For example for people when T = SwapiListItemPeople.
/// Example url: https://swapi.co/api/people/
struct SwapiResponseList<T: Codable>: Codable {
    
    var count: Int
    var next: String?
    var previous: String?
    var results: [T]
}
