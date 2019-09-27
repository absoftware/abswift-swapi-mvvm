//
//  UIStackView+Layout.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

extension UIStackView {
    
    // MARK: - Subviews
    
    func addArrangedSubview(view: UIView, completion: (_ view: UIView) -> Void) {
        self.addArrangedSubview(view)
        completion(view)
    }
}
