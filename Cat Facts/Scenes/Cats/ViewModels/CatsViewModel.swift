//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsViewModel {
    
    let serevice: CatsServices
    var coordinatorDelegate: Coordinator?
    
    init(service: CatsServices) {
        self.serevice = service
    }
}


protocol CatsViewModelType {

    var viewDelegate: CatsViewModelViewDelegate? { get set }

    // Data Source
    var shouldShowHeader: Bool { get }

    var headerText: String { get }

    func numberOfItems() -> Int

    func itemFor(row: Int) -> UITableViewCell // PlaceViewDataType

    // Events
    func add()

    func delete(text: String)

    func didSelectRow(_ row: Int, from controller: UIViewController)

    func didSelectClose(from controller: UIViewController)

}

protocol CatsViewModelCoordinatorDelegate: class {

    func didSelect(cat: Cat, from controller: UIViewController)
    
    func didSelectClose(from viewModel: CatsViewModel, from controller: UIViewController)

}

protocol CatsViewModelViewDelegate: class {

    func updateScreen()
    
//    func updateState(_ state: ViewControllerState)

}
