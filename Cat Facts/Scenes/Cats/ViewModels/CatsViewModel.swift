//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit

class CatsViewModel {
    
    // MARK: - Delegates
    var coordinatorDelegate: CatsCoordinator? // navigate to next
    weak var viewDelegate: CatsViewModelViewDelegate?
    
    // MARK: - Properties
    fileprivate let serevice: CatsServices // save in CoreData
    
    fileprivate var cats: [Cat] = [] {
        didSet {
            self.saveNewCat(cat: cats[cats.count-1])
        }
    }
    
    // MARK: - Init
    init(service: CatsServices) {
        self.serevice = service
    }
    
    func start() {
        // check local db
        // empty -> request for new
        // notEmpty -> show it
        //        let aCat = Cat(_id: "800", text: "a good cat", createdAt: DateFormatter().string(from: Date()))
        //        self.cats.append(aCat)
    }
    
    // MARK: - Network
    func getNewCat() {
        // Use SERVICE class to make request
        // ...
        DispatchQueue.main.async {
            self.viewDelegate?.hud(show: true)
        }
        serevice.fetchCat {
            [weak self]
            (cat, error) in
            guard let sSelf = self else {
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.showError(errorMessage: error.localizedDescription)
                }
                return
            }
            
            if let cat = cat {
                sSelf.cats.append(cat)
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.updateScreen()
                    sSelf.viewDelegate?.hud(show: false)
                }
                return
            }
            sSelf.viewDelegate?.showError(errorMessage: "Some Errors when communicating with the server occured!")
            
        }
    }
    
    // MARK: - Core Data
    func saveNewCat(cat: Cat) {
        serevice.saveCat(cat: cat) {
            [weak self]
            (error) in
            guard let sSelf = self else {
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.showError(errorMessage: error.localizedDescription)
                }
                return
            }
            
            // show success
        }
    }
}

// MARK: - ViewModelType
extension CatsViewModel: CatsViewModelType {
    
    func numberOfItems() -> Int {
        return cats.count
    }
    
    func itemFor(row: Int) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "catID")
        cell.textLabel?.text = CatViewData(cat: self.cats[row])._id
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
        print("Cat in \(row) selected")
        didSelect(cat: cats[row], from: controller)
    }
    
}
protocol CatsViewModelType {
    
    var viewDelegate: CatsViewModelViewDelegate? { get set }
    
    // Data Source
    func numberOfItems() -> Int
    
    func itemFor(row: Int) -> UITableViewCell // PlaceViewDataType
    
    // Events
    func add()
    
    func delete(text: String)
    
    func didSelectRow(_ row: Int, from controller: UIViewController)
    
}

// MARK: - ViewModelCoordinator
protocol CatsViewModelCoordinatorDelegate: class {
    func didSelect(cat: Cat, from controller: UIViewController)
}
extension CatsViewModel: CatsViewModelCoordinatorDelegate {
    func didSelect(cat: Cat, from controller: UIViewController) {
        coordinatorDelegate?.didSelect(cat: cat,
                                       from: controller)
        // It'll open CatDetail VC
    }
}

// MARK: - ViewModelViewDelegate
protocol CatsViewModelViewDelegate: class {
    func updateScreen()
    func hud(show: Bool)
    func showError(errorMessage: String)
}
