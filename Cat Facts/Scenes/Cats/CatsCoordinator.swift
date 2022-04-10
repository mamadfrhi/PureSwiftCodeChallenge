//
//  MainCoordinator.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

//Instantiate ViewController’s & ViewModel’s

class CatsCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let rootNavigationController: UINavigationController
    
    let catsStoryboard = UIStoryboard(name: "Cats", bundle: nil)
    let catDetailsStoryboard = UIStoryboard(name: "CatDetails", bundle: nil)
    
    let apiClient: ApiClient
    let coreDataManager: LocalCRUD
    
    // MARK: VM / VC's
    
    var catsViewModel: CatsViewModel {
        let catsService = CatsServices(apiClient: apiClient, coreDataManager: coreDataManager)
        let viewModel = CatsViewModel(service: catsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }
    
    // MARK: - Coordinator
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
    private func goToCatDetails(with cat: Cat, fom controller: UIViewController) {
        print("I'm going to transfer you to CatDetail VC")
        let catDetailsVC = self.catDetailsStoryboard.instantiateViewController(withIdentifier: "CatDetails") as! CatDetailsViewController
        self.rootNavigationController.pushViewController(catDetailsVC,
                                                         animated: true)
        catDetailsVC.cat = cat
        catDetailsVC.catsVC = controller
    }
}

// MARK: - ViewModel Callback's
//Solid: splitted responsibilities
extension CatsCoordinator : CatsViewModelCoordinatorDelegate {
    func didSelect(cat: Cat, from controller: UIViewController) {
        print("I'm in CatsCoordinator and user selected \(cat)")
        self.goToCatDetails(with: cat, fom: controller)
    }
}

// MARK: - Coordinator Callback's
// sOlid: If we'd have child coordinator
extension CatsCoordinator { //: CatCoordinatorDelegate
//    func didFinish(from coordinator: CatsCoordinator) {
//        removeChildCoordinator(coordinator)
//    }
}
