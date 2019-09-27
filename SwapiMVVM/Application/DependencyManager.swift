//
//  DependencyManager.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 26/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

/// This class keeps all services and other depenendencies
/// which will be delivered to view models.
class DependencyManager {
    
    // MARK: - Application
    
    let application: UIApplication
    
    let rootNavigationController: UINavigationController
    
    // MARK: - Public services
    
    let swapi = SwapiService(privateSession: false, completionOnMainThread: true)
    
    // MARK: - Private service controllers
    
    // Service controllers here...
    
    // MARK: - Properties
    
    // Properties here...
    
    // MARK: - Initializers
    
    init(application: UIApplication, rootNavigationController: UINavigationController) {
        // Set dependencies.
        self.application = application
        self.rootNavigationController = rootNavigationController
    }
    
    // MARK: - Application delegate methods
    
    func didFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

    }
    
    func willResignActive() {
        
    }
    
    func didEnterBackground() {
        
    }
    
    func willEnterForeground() {

    }
    
    func didBecomeActive() {
        
    }
    
    func willTerminate() {

    }
}
