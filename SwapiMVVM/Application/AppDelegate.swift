//
//  AppDelegate.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 26/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    var window: UIWindow?
    
    var dependencyManager: DependencyManager!
    
    // MARK: - UIApplicationDelegate methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create root navigation controller.
        let navigationController = UINavigationController()
        
        // Create dependency manager.
        self.dependencyManager = DependencyManager(
            application: application,
            rootNavigationController: navigationController)
        
        // Create main screen
        MainScreenFactory.rootIn(
            navigationController: navigationController,
            dependencyManager: self.dependencyManager)
        
        // Initialize window.
        self.window = UIWindow()
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.window?.frame = UIScreen.main.bounds
        
        return true
    }
    
    /// Sent when the application is about to move from active to inactive state.
    /// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
    /// or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
    /// Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {
        // Notify services about event.
        self.dependencyManager.willResignActive()
    }

    /// Use this method to release shared resources, save user data, invalidate timers,
    /// and store enough application state information to restore your application
    /// to its current state in case it is terminated later. If your application supports background execution,
    /// this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Notify services about event.
        self.dependencyManager.didEnterBackground()
    }

    /// Called as part of the transition from the background to the active state;
    /// here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Notify services about event.
        self.dependencyManager.willEnterForeground()
    }

    /// Restart any tasks that were paused (or not yet started) while the application was inactive.
    /// If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Notify services about event.
        self.dependencyManager.didBecomeActive()
    }

    /// Called when the application is about to terminate.
    /// Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        // Notify services about event.
        self.dependencyManager.willTerminate()
    }
}
