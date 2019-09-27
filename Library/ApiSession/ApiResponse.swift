//
//  ApiResponse.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

struct ApiResponse {
    
    var httpCode: Int = 0
    var header: [String: String] = [:]
    var cookies: [String: ApiCookie] = [:]
    var data: Data?
}

struct ApiDecodedResponse<T: Decodable> {
    
    var httpCode: Int = 0
    var header: [String: String] = [:]
    var cookies: [String: ApiCookie] = [:]
    var data: T
}
