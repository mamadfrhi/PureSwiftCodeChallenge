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
    
    let storyboard = UIStoryboard(name: "Cats", bundle: nil)
    
    let apiClient: ApiClient
    
    // MARK: VM / VC's
    
    var catsViewModel: CatsViewModel {
        let catsService = CatsServices(apiClient: apiClient)
        let viewModel = CatsViewModel(service: catsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }
    
    // MARK: - Coordinator
    init(rootNavigationViewController: UINavigationController, apiClient: ApiClient) {
        self.rootNavigationController = rootNavigationViewController
        self.apiClient = apiClient
    }
    
    override func start() {
        let catsVC: CatsViewController = storyboard.instantiateViewController(withIdentifier: "Cats") as! CatsViewController
        catsVC.viewModel = catsViewModel
        rootNavigationController.setViewControllers([catsVC], animated: false)
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        // delegate?.didFinish(from: self)
    }
    
}

// MARK: - Navigation
extension CatsCoordinator {
//    func goToLocationSearch(searchType: LocationSearchType, from controller: UIViewController) {
//        let viewController: LocationSearchViewController = storyboard.instantiateViewController()
//        viewController.viewModel = locationSearchViewModel
//        controller.present(viewController, animated: true, completion: nil)
//    }
    
    func goToCatDetails() {
        print("I can transfer you to cat detail")
    }
}
// MARK: - Coordinator Callback's
extension CatsCoordinator: CatsViewModelCoordinatorDelegate
{
    func didSelect(cat: Cat, from controller: UIViewController) {
        print("I'm in CatsCoordinator and user selected \(cat)")
        self.goToCatDetails()
    }
}

// MARK: - ViewModel Callback's
extension CatsCoordinator//: SearchInputViewModelCoordinatorDelegate
{
    //    func didSelectOrigin(from controller: UIViewController) {
    //        goToLocationSearch(searchType: .origin, from: controller)
    //    }
}
