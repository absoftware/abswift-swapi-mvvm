//
//  MainScreenFactory.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class MainScreenFactory: NSObject {

    static func rootIn(navigationController: UINavigationController, dependencyManager: DependencyManager) {

        // View controller
        let viewController = MainScreenFactory.create(
            navigationController: navigationController,
            dependencyManager: dependencyManager)

        // Root controller
        navigationController.viewControllers = [viewController]
    }

    static func create(navigationController: UINavigationController, dependencyManager: DependencyManager) -> MainScreenViewController {

        // View controller
        let viewController = MainScreenViewController()
        viewController.title = localizedString("Star Wars API")

        // Flow controller
        let flowController = MainScreenFlowController(
            navigationController: navigationController,
            viewController: viewController,
            dependencyManager: dependencyManager)

        // View model
        let viewModel = MainScreenViewModel(
            flowController: flowController,
            swapi: dependencyManager.swapi)
        viewModel.delegate = viewController
        viewController.viewModel = viewModel

        // Return controller
        return viewController
    }
}
