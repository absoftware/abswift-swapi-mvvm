//
//  SwapiListItemPeople.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

/// Response for single person.
/// Example url: https://swapi.co/api/people/1/
struct SwapiListItemPeople: Codable, SwapiListItemProtocol {

    var name: String
    var birthYear: String
    var eyeColor: String
    var gender: SwapiGender

    /// Custom coding keys.
    /// We want properties with camel cased names
    /// but JSON contains names with underscores.
    enum CodingKeys: String, CodingKey {
        case name
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case gender
    }
}
