//
//  AlertFactory.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 01/10/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class AlertFactory {

    static func showIn(parentController: UIViewController, title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction]?, dependencyManager: DependencyManager) {

        // View controller
        let viewController = AlertFactory.create(
            title: title,
            message: message,
            preferredStyle: preferredStyle,
            actions: actions,
            dependencyManager: dependencyManager)

        // Present controller
        parentController.present(viewController, animated: true, completion: nil)
    }

    static func create(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction]?, dependencyManager: DependencyManager) -> AlertViewController {

        // View controller
        let viewController = AlertViewController(
            title: title,
            message: message,
            preferredStyle: preferredStyle)

        // Add actions
        if let actions = actions {
            for action in actions {
                viewController.addAction(action)
            }
        }

        // Return controller
        return viewController
    }
}
