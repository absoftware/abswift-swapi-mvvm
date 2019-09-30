//
//  PeopleFactory.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class PeopleFactory: NSObject {
    
    static func pushIn(navigationController: UINavigationController, url: String, dependencyManager: DependencyManager) {

        // View controller
        let viewController = PeopleFactory.create(
            navigationController: navigationController,
            url: url,
            dependencyManager: dependencyManager)

        // Push controller
        navigationController.pushViewController(viewController, animated: true)
    }

    static func create(navigationController: UINavigationController, url: String, dependencyManager: DependencyManager) -> PeopleViewController {

        // View controller
        let viewController = PeopleViewController()
        viewController.title = localizedString("People")

        // Flow controller
        let flowController = PeopleFlowController(
            navigationController: navigationController,
            viewController: viewController,
            dependencyManager: dependencyManager)

        // View model
        let viewModel = PeopleViewModel(
            flowController: flowController,
            swapi: dependencyManager.swapi,
            url: url)
        viewModel.delegate = viewController
        viewController.viewModel = viewModel

        // Return controller
        return viewController
    }
}
