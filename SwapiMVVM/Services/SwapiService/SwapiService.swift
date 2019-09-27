//
//  SwapiService.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

class SwapiService {
    
    // MARK: - Properties
    
    static let retryCount: Int = 3
    static let timeout: TimeInterval = 10.0
    static let apiUrl = "https://swapi.co/api/"
    
    let session: ApiSession
    let completionOnMainThread: Bool

    // MARK: - Initializers

    init(privateSession: Bool, completionOnMainThread: Bool) {
        self.session = ApiSession(privateSession: privateSession)
        self.completionOnMainThread = completionOnMainThread
    }
    
    // MARK: - Requests
    
    func getRoot(completionHandler: @escaping (_ result: Result<ApiDecodedResponse<SwapiResponseRoot>, ApiError>) -> Void) {
        
        self.session.requestJson(
            method: .get,
            url: SwapiService.apiUrl,
            query: nil,
            dataType: SwapiResponseRoot.self,
            retry: SwapiService.retryCount,
            timeout: SwapiService.timeout,
            completionOnMainThread: self.completionOnMainThread,
            completionHandler: completionHandler)
    }
}
