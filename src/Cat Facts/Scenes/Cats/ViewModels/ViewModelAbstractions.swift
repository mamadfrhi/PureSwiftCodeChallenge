//
//  ViewModelAbstractions.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import UIKit

// MARK: - ViewModelType
// implement in VM
protocol CatsViewModelType {
    
    var viewDelegate: CatsViewModelViewDelegate? { get set }
    
    // Data Source
    func numberOfRows() -> Int
    
    func cellDataFor(row: Int) -> CatViewData
    
    // Events
    func add()
    
    func delete()
    
    func didSelectRow(_ row: Int, from controller: UIViewController)
    
    func refreshView()
}

// MARK: - ViewModelCoordinator(delegate)
// implement in CatsCoordinator
// call in VM
protocol CatsViewModelCoordinatorDelegate: class {
    func didSelect(cat: Cat, from controller: UIViewController)
}

// MARK: - ViewModelViewDelegate
// implement in VC
// call on VM
protocol CatsViewModelViewDelegate: class {
    func updateScreen()
    func hud(show: Bool)
    func showError(errorMessage: String)
    func selectedCatRow() -> Int
}
