//
//  ViewModelAbstractions.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import UIKit

// MARK: - ViewModelViewDelegate
protocol CatsViewModelViewDelegate: class {
    func updateScreen()
    func hud(show: Bool)
    func showError(errorMessage: String)
    func selectedCatIndex() -> Int
}

// MARK: - ViewModelType
protocol CatsViewModelType {
    
    var viewDelegate: CatsViewModelViewDelegate? { get set }
    
    // Data Source
    func numberOfItems() -> Int
    
    func itemFor(row: Int) -> UITableViewCell // PlaceViewDataType
    
    // Events
    func add()
    
    func delete(cat: Cat)
    
    func didSelectRow(_ row: Int, from controller: UIViewController)
    
}

// MARK: - ViewModelCoordinator
protocol CatsViewModelCoordinatorDelegate: class {
    func didSelect(cat: Cat, from controller: UIViewController)
}
