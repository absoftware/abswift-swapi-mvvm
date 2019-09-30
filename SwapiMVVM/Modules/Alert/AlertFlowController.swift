//
//  AlertFlowController.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 01/10/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

class AlertFlowController {
    
    // MARK: - Dependencies

    weak var navigationController: UINavigationController!
    weak var viewController: PeopleViewController!
    let dependencyManager: DependencyManager

    // MARK: - Initializers

    init(navigationController: UINavigationController, viewController: PeopleViewController, dependencyManager: DependencyManager) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.dependencyManager = dependencyManager
    }

    // MARK: - Actions

    func showAlert() {
        
    }
}
