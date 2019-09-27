//
//  IndexPath+Extension.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

extension IndexPath {
    
    // MARK: - Conversion to integer
    
    static let maximumNumberOfRowsInSection = 10000000
    
    init(integerValue: Int) {
        self.init(
            item: integerValue%IndexPath.maximumNumberOfRowsInSection,
            section: integerValue/IndexPath.maximumNumberOfRowsInSection)
    }
    
    var integerValue: Int {
        return self.section*IndexPath.maximumNumberOfRowsInSection + self.item
    }
}
