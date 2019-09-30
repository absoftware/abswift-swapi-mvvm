//
//  PeopleItemCell.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 01/10/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

class PeopleItemCell: UITableViewCell {
    
    // MARK: - Subviews

    // Subviews go here...
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.internalInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.internalInit()
    }
    
    fileprivate func internalInit() {
        // Initialize view and subviews here...
    }

    // MARK: - UIView methods

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
