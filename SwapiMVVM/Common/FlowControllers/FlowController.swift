//
//  FlowController.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 01/10/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

class FlowController {
    
    // MARK: - Dependencies

    private weak var navigationController: UINavigationController?
    private weak var parentController: UIViewController?
    private let dependencyManager: DependencyManager

    // MARK: - Initializers

    init(navigationController: UINavigationController?, parentController: UIViewController?, dependencyManager: DependencyManager) {
        self.navigationController = navigationController
        self.parentController = parentController
        self.dependencyManager = dependencyManager
    }

    // MARK: - Alerts

    func show(apiError: ApiError) {
        guard let parentController = self.parentController else {
            return
        }

        // Create action
        let action = UIAlertAction(
            title: localizedString("OK"),
            style: .cancel,
            handler: nil)

        // Show alert
        AlertFactory.showIn(
            parentController: parentController,
            title: nil,
            message: apiError.consoleDescription(),
            preferredStyle: .alert,
            actions: [action],
            dependencyManager: self.dependencyManager)
    }
}
