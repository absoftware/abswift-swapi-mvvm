//
//  SwapiResponseRoot.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

struct SwapiResponseRoot: Decodable {
    
    var people: String
    var planets: String
    var films: String
    var species: String
    var vehicles: String
    var starships: String
}
