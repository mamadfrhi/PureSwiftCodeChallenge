//
//  MainCoordinator.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

//Instantiate ViewController(s) & ViewModel(s)

class CatsCoordinator: Coordinator {
    
    // MARK: Properties
    
    private let rootNavigationController: UINavigationController
    
    private let catsStoryboard = UIStoryboard(name: "Cats", bundle: nil)
    private let catDetailsStoryboard = UIStoryboard(name: "CatDetails", bundle: nil)
    
    private let apiClient: ApiClient
    private let coreDataManager: LocalCRUD
    
    // MARK: VM
    
    private var catsViewModel: CatsViewModel {
        let catsService = CatsServices(apiClient: apiClient, coreDataManager: coreDataManager)
        let viewModel = CatsViewModel(service: catsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }
    
    // MARK: Coordinator
    init(rootNavigationViewController: UINavigationController,
         apiClient: ApiClient,
         coreDataManager: LocalCRUD) {
        self.rootNavigationController = rootNavigationViewController
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
    }
    
    override func start() {
        let catsVC: CatsViewController = catsStoryboard.instantiateViewController(withIdentifier: "Cats") as! CatsViewController
        catsVC.viewModel = catsViewModel
        rootNavigationController.setViewControllers([catsVC], animated: false)
    }
    
    override func finish() {
        // sOlid
    }
    
}

// MARK: - Navigation
extension CatsCoordinator {
    private func goToCatDetails(with cat: Cat, from controller: UIViewController) {
        print("\n I'm going to transfer you to CatDetail VC \n")
        let catDetailsVC = self.catDetailsStoryboard.instantiateViewController(withIdentifier: "CatDetails") as! CatDetailsViewController
        self.rootNavigationController.pushViewController(catDetailsVC,
                                                         animated: true)
        catDetailsVC.cat = cat
        catDetailsVC.parentVC = controller
    }
}

// MARK: - ViewModel Callbacks
//Solid: splitted responsibilities
extension CatsCoordinator : CatsViewModelCoordinatorDelegate {
    func didSelect(cat: Cat, from controller: UIViewController) {
        print("\n I'm in CatsCoordinator and user selected \(cat) \n")
        self.goToCatDetails(with: cat, from: controller)
    }
}

// MARK: - Coordinator Callbacks
// sOlid: If we'd have child coordinator
extension CatsCoordinator { //: CatCoordinatorDelegate
//    func didFinish(from coordinator: CatsCoordinator) {
//        removeChildCoordinator(coordinator)
//    }
}
