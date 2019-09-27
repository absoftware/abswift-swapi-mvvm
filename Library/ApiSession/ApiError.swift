//
//  ApiError.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

class ApiError: Error {

    // MARK: - Error codes

    enum Code: Int {
        case apiError               // HTTP code = 200 and JSON with error is returned.
        case invalidResponseData    // Body of response is different than expected.
        case invalidUrl             // Creation of URL for request is not possible.
        case invalidQuery           // Creation of query for request is not possible.
        case httpBadRequest         // HTTP code = 400.
        case httpForbidden          // HTTP code = 403.
        case httpNotFound           // HTTP code = 404.
        case httpServerError        // HTTP code = 5xx.
        case httpUnauthorized       // HTTP code = 401.
        case httpUnknown            // HTTP code is different than supported by us.
        case noInternetConnection   // No internet connection.
        case unknown                // Unknown case.
    }

    // MARK: - Properties

    let error: Error?

    let code: Code

    // MARK: - Initializers

    init(error: Error) {
        self.code = .unknown
        self.error = error
    }

    init(code: Code, error: Error? = nil) {
        self.code = code
        self.error = error
    }

    // MARK: - Actions

    func consoleDescription() -> String {
        if let apiError = self.error as? ApiError {
            return "Error code [\(self.code)][apiError.code=\(apiError.code)]: \(String(describing: apiError.error))"
        } else if let urlError = self.error as? URLError {
            return "Error code [\(self.code)][urlError.code=\(urlError.code.rawValue)]: \(String(describing: urlError))"
        } else {
            return "Error code [\(self.code)]: \(String(describing: self.error))"
        }
    }
}
