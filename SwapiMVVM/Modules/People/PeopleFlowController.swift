//
//  PeopleFlowController.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class PeopleFlowController: FlowController {
    
    // MARK: - Dependencies

    weak var navigationController: UINavigationController!
    weak var viewController: PeopleViewController!
    let dependencyManager: DependencyManager

    // MARK: - Initializers

    init(navigationController: UINavigationController, viewController: PeopleViewController, dependencyManager: DependencyManager) {
        self.navigationController = navigationController
        self.viewController = viewController
        self.dependencyManager = dependencyManager
        super.init(
            navigationController: navigationController,
            parentController: viewController,
            dependencyManager: dependencyManager)
    }

    // MARK: - Actions

    // Navigation actions here...
}
