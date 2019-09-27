//
//  ApiSession.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

private func internalLog(_ format: String, _ args: CVarArg..., file: String = #file, function: String = #function, line: Int = #line) {
    log(format, args, file: file, function: function, line: line)
}

private func internalEcho(_ text: String) {
    echo(text)
}

class ApiSession: NSObject, URLSessionTaskDelegate {

    // MARK: - Properties

    private var urlSession: URLSession!

    // MARK: - Initializers

    init(privateSession: Bool) {
        super.init()
        let configuration = privateSession ? URLSessionConfiguration.ephemeral : URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    // MARK: - Actions

    func clear() {
        self.deleteAllCookies()
    }

    // MARK: - Cookies

    func getCookieValue(name: String, domain: String) -> String? {
        guard let storage = self.urlSession.configuration.httpCookieStorage else {
            return nil
        }
        return storage.cookies?.first { $0.name == name && $0.domain == domain }?.value
    }

    @discardableResult
    func setCookie(name: String, value: String, domain: String, path: String = "/", version: String = "0") -> Bool {
        let cookieParams = [
            HTTPCookiePropertyKey.name: name,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: path,
            HTTPCookiePropertyKey.version: version,
            HTTPCookiePropertyKey.discard: "TRUE"
        ]
        if let cookie = HTTPCookie(properties: cookieParams), let storage = self.urlSession.configuration.httpCookieStorage {
            storage.setCookie(cookie)
            return true
        } else {
            return false
        }
    }

    func deleteCookie(name: String, domain: String) {
        guard let storage = self.urlSession.configuration.httpCookieStorage else {
            return
        }
        if let cookie = storage.cookies?.first(where: { $0.name == name && $0.domain == domain }) {
            storage.deleteCookie(cookie)
        }
    }

    func deleteAllCookies() {
        guard let storage = self.urlSession.configuration.httpCookieStorage, let cookies = storage.cookies else {
            return
        }
        for cookie in cookies {
            storage.deleteCookie(cookie)
        }
    }

    // MARK: - Requests

    /// Params:
    /// - method: Post or get method.
    /// - url: Absolute url for request.
    /// - query: Body or get parameters.
    /// - retry: Retry count.
    /// - timeout: Number of seconds for single try. Total timeout is (retry + 1)*timeout.
    /// - completionHandler: Notifies about response. It is called always.
    func request(method: ApiRequestMethod, url: String, query: [String: Any]?, retry: Int, timeout: TimeInterval, completionHandler: @escaping (_ result: Result<ApiResponse, ApiError>) -> Void) {

        // Log input data.
        internalLog("\(method) \(url) \(query?.consoleDescription() ?? "")")

        // Create url.
        guard let requestUrl = URL(string: url) else {

            // Return error about invalid URL.
            internalLog("\(method) \(url) error = invalid url")
            completionHandler(.failure(ApiError(code: .invalidUrl)))
            return
        }

        // Create request.
        var request = URLRequest(
            url: requestUrl,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        request.allowsCellularAccess = true
        request.httpShouldHandleCookies = true
        request.cachePolicy = .reloadIgnoringLocalCacheData

        // Body.
        if let query = query {
            request.httpBody = query.percentEscaped.data(using: .utf8)
        }

        // Log network request before sending.
        self.log(request: request)

        // Create task.
        var dataTask: URLSessionDataTask!
        dataTask = self.urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            // Log network traffic.
            self.log(dataTask: dataTask, response: response, data: data)

            // Handle errors.
            if let urlError = error as? URLError {

                // Handle url errors.
                switch urlError.code {
                case URLError.notConnectedToInternet, URLError.networkConnectionLost, URLError.dnsLookupFailed:
                    if retry > 0 {
                        internalLog("\(method) \(url) will retry = \(retry)")
                        self.request(
                            method: method,
                            url: url,
                            query: query,
                            retry: retry - 1,
                            timeout: timeout,
                            completionHandler: completionHandler)
                    } else {
                        internalLog("\(method) \(url) url error = \(urlError)")
                        completionHandler(.failure(ApiError(code: .noInternetConnection, error: urlError)))
                    }
                default:
                    internalLog("\(method) \(url) url error = \(urlError)")
                    completionHandler(.failure(ApiError(error: urlError)))
                }

            } else if let error = error {

                // Handle unknown errors.
                internalLog("\(method) \(url) error = \(error)")
                completionHandler(.failure(ApiError(error: error)))

            } else if let httpResponse = response as? HTTPURLResponse {

                // Handle action based on returned HTTP code.
                internalLog("\(method) \(url) status code = \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {

                    // Copy cookies.
                    var cookies: [String: ApiCookie] = [:]
                    for cookie in HTTPCookie.cookies(withResponseHeaderFields: httpResponse.headerFields, for: requestUrl) {
                        cookies[cookie.name] = ApiCookie(name: cookie.name, value: cookie.value)
                    }

                    // Success.
                    var apiResponse = ApiResponse()
                    apiResponse.httpCode = httpResponse.statusCode
                    apiResponse.header = httpResponse.headerFields
                    apiResponse.cookies = cookies
                    apiResponse.data = data
                    completionHandler(.success(apiResponse))

                } else if httpResponse.statusCode == 400 {

                    // Bad request.
                    completionHandler(.failure(ApiError(code: .httpBadRequest)))

                } else if httpResponse.statusCode == 401 {

                    // Unauthorized.
                    completionHandler(.failure(ApiError(code: .httpUnauthorized)))

                } else if httpResponse.statusCode == 403 {

                    // Forbidden.
                    completionHandler(.failure(ApiError(code: .httpForbidden)))

                } else if httpResponse.statusCode == 404 {

                    // Not found.
                    completionHandler(.failure(ApiError(code: .httpNotFound)))

                } else if httpResponse.statusCode >= 500 && httpResponse.statusCode < 600 {

                    // Server error.
                    completionHandler(.failure(ApiError(code: .httpServerError)))

                } else {

                    // Unknown http error.
                    completionHandler(.failure(ApiError(code: .httpUnknown)))
                }

            } else {

                // Handle completely unknown error because of missing response object.
                internalLog("\(method) \(url) error = missing response")
                completionHandler(.failure(ApiError(code: .unknown)))
            }
        }

        // Resume task.
        dataTask.resume()
    }

    /// This method works like request method, but callback is called on main thread if needed.
    func request(method: ApiRequestMethod, url: String, query: [String: Any]?, retry: Int, timeout: TimeInterval, completionOnMainThread: Bool, completionHandler: @escaping (_ result: Result<ApiResponse, ApiError>) -> Void) {

        if completionOnMainThread {
            self.request(method: method, url: url, query: query, retry: retry, timeout: timeout) { result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
        } else {
            self.request(method: method, url: url, query: query, retry: retry, timeout: timeout, completionHandler: completionHandler)
        }
    }

    /// This method works like request method, but callback returns decoded response.
    func requestJson<T>(method: ApiRequestMethod, url: String, query: [String: Any]?, dataType: T.Type, retry: Int, timeout: TimeInterval, completionHandler: @escaping (_ result: Result<ApiDecodedResponse<T>, ApiError>) -> Void) where T: Decodable {

        self.request(method: method, url: url, query: query, retry: retry, timeout: timeout) { result in

            do {

                // Get API response.
                let apiResponse = try result.get()

                // Get data. In this case it's required when we want to decode something.
                guard let data = apiResponse.data else {

                    // Report error, because for HTTP code = 200 we should get some JSON.
                    internalLog("\(method) \(url) error = missing JSON")
                    completionHandler(.failure(ApiError(code: .invalidResponseData)))
                    return
                }

                do {

                    // Decode success response.
                    let decodedData = try JSONDecoder().decode(dataType.self, from: data)
                    internalLog("\(method) \(url) decoded response")

                    // Log decoded response.
                    self.log(data: decodedData)

                    // Call completion handler with decoded response.
                    var apiDecodedResponse = ApiDecodedResponse<T>(data: decodedData)
                    apiDecodedResponse.httpCode = apiResponse.httpCode
                    apiDecodedResponse.header = apiResponse.header
                    apiDecodedResponse.cookies = apiResponse.cookies
                    completionHandler(.success(apiDecodedResponse))

                } catch let decoderError {

                    // Report error.
                    internalLog("\(method) \(url) error = \(decoderError)")
                    completionHandler(.failure(ApiError(code: .invalidResponseData, error: decoderError)))
                }

            } catch let apiError as ApiError {

                // Forward error to the caller.
                internalLog("\(method) \(url) error = \(apiError)")
                completionHandler(.failure(apiError))

            } catch let error {

                // Forward error to the caller.
                internalLog("\(method) \(url) error = \(error)")
                completionHandler(.failure(ApiError(error: error)))
            }
        }
    }

    /// This method works like requestJson method, but callback is called on main thread if needed.
    func requestJson<T>(method: ApiRequestMethod, url: String, query: [String: Any]?, dataType: T.Type, retry: Int, timeout: TimeInterval, completionOnMainThread: Bool, completionHandler: @escaping (_ result: Result<ApiDecodedResponse<T>, ApiError>) -> Void) where T: Decodable {

        if completionOnMainThread {
            self.requestJson(method: method, url: url, query: query, dataType: dataType, retry: retry, timeout: timeout) { result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
        } else {
            self.requestJson(method: method, url: url, query: query, dataType: dataType, retry: retry, timeout: timeout, completionHandler: completionHandler)
        }
    }

    // MARK: - Logs

    private func log(request: URLRequest) {

        internalEcho("\n\n")
        internalEcho("👉 P R E P A R I N G   R E Q U E S T\n")

        internalEcho("📌 SESSION CONFIGURATION\n")
        internalEcho(self.urlSession.configuration.consoleDescription())
        internalEcho("\n")

        internalEcho("📌 REQUEST\n")
        internalEcho(request.consoleDescription())
        internalEcho("\n")

        internalEcho("✋ P R E P A R A T I O N S   H A S   E N D E D")
        internalEcho("\n\n")
    }

    private func log(dataTask: URLSessionDataTask, response: URLResponse?, data: Data?) {

        internalEcho("\n\n")
        internalEcho("👉 R E S P O N S E   A R R I V E D\n")

        internalEcho("📌 ORIGINAL REQUEST\n")
        internalEcho(dataTask.originalRequest?.consoleDescription() ?? "")
        internalEcho("\n")

        internalEcho("📌 CURRENT REQUEST\n")
        internalEcho(dataTask.currentRequest?.consoleDescription() ?? "")
        internalEcho("\n")

        internalEcho("📌 RESPONSE\n")
        if let httpResponse = response as? HTTPURLResponse {
            internalEcho(httpResponse.consoleDescription(data: data))
        } else {
            internalEcho("Response is not an HTTP response.\n")
        }
        internalEcho("\n")

        internalEcho("✋ R E S P O N S E   H A S   E N D E D")
        internalEcho("\n\n")
    }

    private func log<T: Decodable>(data: T) {

        internalEcho("\n\n")
        internalEcho("👉 D E C O D E D   R E S P O N S E\n")

        internalEcho("\(data)")
        internalEcho("\n")

        internalEcho("✋ D E C O D E D   R E S P O N S E   H A S   E N D E D")
        internalEcho("\n\n")
    }
}
