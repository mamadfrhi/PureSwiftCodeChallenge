//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsViewModel {

    // MARK: - Delegates
    weak var coordinatorDelegate: CatsCoordinator? // navigate to next
    weak var viewDelegate: CatsViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let serevice: CatsServices // save in CoreData

    fileprivate var cats: [Cat] = []

    // MARK: - Init
    init(service: CatsServices) {
        self.serevice = service
    }

    func start() {
        // check local db
        // empty -> request for new
        // notEmpty -> show it
        let aCat = Cat(_id: "800", text: "a good cat", createdAt: DateFormatter().string(from: Date()))
        self.cats.append(aCat)
    }
    
    // MARK: - Network
    func getNewCat() {
        // Use SERVICE class to make request
        // ...
        serevice.fetchCat()
        viewDelegate?.updateScreen()
    }
}

extension CatsViewModel: CatsViewModelType {
    
    var titleText: String {
        return "Cats"
    }
    
    func numberOfItems() -> Int {
        return cats.count
    }
    
    func itemFor(row: Int) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "catID")
        cell.textLabel?.text = self.cats[row].text
        cell.detailTextLabel?.text = CatViewData(cat: self.cats[row]).createdAt
        return cell
    }
    
    func add() {
        print("To add a new cat")
        getNewCat()
        viewDelegate?.updateScreen()
    }
    
    func delete(text: String) {
        print("Delete \(text) cat")
    }
    
    func didSelectRow(_ row: Int, from controller: UIViewController) {
        print("Cat in \(row) selecte")
    }
    
}
protocol CatsViewModelType {

    var viewDelegate: CatsViewModelViewDelegate? { get set }

    // Data Source
    var titleText: String { get }

    func numberOfItems() -> Int

    func itemFor(row: Int) -> UITableViewCell // PlaceViewDataType

    // Events
    func add()

    func delete(text: String)

    func didSelectRow(_ row: Int, from controller: UIViewController)

}

protocol CatsViewModelCoordinatorDelegate: class {

    func didSelect(cat: Cat, from controller: UIViewController)
    
}

protocol CatsViewModelViewDelegate: class {

    func updateScreen()
    
}
