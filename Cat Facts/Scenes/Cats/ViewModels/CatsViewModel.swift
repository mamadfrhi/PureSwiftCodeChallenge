//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit
import CoreData

class CatsViewModel {
    
    // MARK: - Delegates
    var coordinatorDelegate: CatsCoordinator? // navigate to next
    weak var viewDelegate: CatsViewModelViewDelegate?
    
    // MARK: - Properties
    fileprivate let service: CatsServices // save in CoreData
    
    fileprivate var cats: [Cat] = [] {
        willSet {
            if newValue.count == 1 {
                // if an element appended, so save it locally
                self.saveNewCat(cat: newValue[0])
            }
        }
    }
    fileprivate var catsNSManagedObjects: [NSManagedObject]?
    
    // MARK: - Init
    init(service: CatsServices) {
        self.service = service
    }
    
    func start() {
        service.fetchLocalCats {
            [weak self]
            (catsNSObjectArray, error) in
            guard let sSelf = self,
                  let catsNSObjectArray = catsNSObjectArray as? [NSManagedObject] else {
                return
            }
            sSelf.catsNSManagedObjects = catsNSObjectArray
            let cats = CatCoreDataConvertor().giveMeCats(from: catsNSObjectArray)
            sSelf.cats = cats
        }
    }
    
    // MARK: - Network
    func getNewCat() {
        // Use SERVICE class to make request
        // ...
        DispatchQueue.main.async {
            self.viewDelegate?.hud(show: true)
        }
        service.fetchCat {
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
        service.saveCat(cat: cat) {
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
    func remove(cat: Cat) {
        // convert cat to nsManagedObject
        let indexToRemove = viewDelegate!.selectedCatIndex() // Take care of force unwrap
        guard let catNSManagedObj = self.catsNSManagedObjects?[indexToRemove] else { return }
        service.delete(cat: catNSManagedObj) {
            [weak self]
            (deleted, error) in
            guard let sSelf = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.showError(errorMessage: error.localizedDescription)
                }
                return
            }
            
            if deleted {
                sSelf.catsNSManagedObjects?.remove(at: indexToRemove)
                sSelf.cats.remove(at: indexToRemove)
                sSelf.viewDelegate?.updateScreen()
            }
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
        let catViewData = CatViewData(cat: self.cats[row])
        cell.textLabel?.text = catViewData._id
        cell.detailTextLabel?.text = catViewData.createdAt
        return cell
    }
    
    func add() {
        print("To add a new cat")
        getNewCat()
        viewDelegate?.updateScreen()
    }
    
    func delete(cat: Cat) {
        print("Delete \(cat) cat")
        self.remove(cat: cat)
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
    
    func delete(cat: Cat)
    
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
    func selectedCatIndex() -> Int
}
