//
//  AppDelegate.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    // start the app
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup Coordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        return true
    }
    
    // background
    func applicationDidEnterBackground(_ application: UIApplication) {
        // because interruption might happen 
        CoreDataContainer.shared.saveContext()
    }
}

