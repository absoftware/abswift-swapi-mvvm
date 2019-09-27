//
//  ServiceListener.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 26/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

protocol ServiceListener {
    
    /// Use it to subscribe self as service listener.
    func startListening()
    
    /// Use it to unsubscribe self from service listeners.
    func stopListening()
}
