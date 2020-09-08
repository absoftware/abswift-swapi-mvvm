//
//  Data+Extensions.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 08/09/2020.
//  Copyright © 2020 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

extension Data {

    var ascii: String? {
        return String(data: self, encoding: .ascii)
    }

    var utf8: String? {
        return String(data: self, encoding: .utf8)
    }

    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {
            return nil
        }
        return data.utf8
    }
}
