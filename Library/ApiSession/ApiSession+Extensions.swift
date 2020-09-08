//
//  ApiSession+Extensions.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

extension Dictionary {

    var percentEscaped: String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }.joined(separator: "&")
    }
}

extension CharacterSet {

    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension Dictionary {

    func consoleDescription() -> String {
        var headerLines = [String]()
        for (key, value) in self {
            headerLines.append("\(key): \(value)")
        }
        return headerLines.joined(separator: "\n")
    }
}

extension URLRequest {

    func consoleDescription() -> String {
        let method = self.httpMethod ?? "UNKNOWN"
        let url = self.url?.absoluteString ?? ""
        let headers = self.allHTTPHeaderFields?.consoleDescription() ?? ""
        let body = self.httpBody != nil ? String(data: self.httpBody!, encoding: .utf8) ?? "" : ""
        return "\(method) \(url)\n\(headers)\n\n\(body)"
    }
}

extension URLSessionConfiguration {

    func consoleDescription() -> String {
        let headers = self.httpAdditionalHeaders?.consoleDescription() ?? ""
        let cookies = self.httpCookieStorage?.cookies?.map { "\($0.name): \($0.value) [\(String(describing: $0.properties))]" }.joined(separator: "\n") ?? ""
        return "Headers:\n\(headers)\n\nCookies:\n\(cookies)"
    }
}

extension HTTPURLResponse {

    var headerFields: [String: String] {
        var fields: [String: String] = [:]
        for (key, value) in self.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                fields[key] = value
            }
        }
        return fields
    }

    func consoleDescription(data: Data?) -> String {
        let code = self.statusCode
        let headers = self.allHeaderFields.consoleDescription()
        let body = data?.prettyJson ?? data?.utf8 ?? ""
        return "HTTP \(code)\n\(headers)\n\n\(body)"
    }
}
