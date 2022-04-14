//
//  AppCoordinator.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: Properties
    let window: UIWindow?
    
    var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    var apiClient: Network = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json; charset=utf-8"]
        let apiClient = ApiClient(configuration: configuration)
        return apiClient
    }()
    
    lazy var coreDataManager = CoreDataManager()
    
    // MARK: Coordinator
    init(window: UIWindow?) { self.window = window }
    
    override func start() {
        guard let window = window else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        // show Cats.storyboard as the start point of the app
        let catsCoordinator = CatsCoordinator(rootNavigationViewController: rootViewController,
                                              apiClient: apiClient,
                                              coreDataManager: coreDataManager)
        catsCoordinator.start()
    }
    
    override func finish() { /* sOlid */ }
    
}
