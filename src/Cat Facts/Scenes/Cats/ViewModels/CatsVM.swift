//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import UIKit
import CoreData

class CatsVM {
    
    // MARK: Delegates
    var coordinatorDelegate: CatsViewModelCoordinatorDelegate?
    var viewDelegate: CatsViewModelViewDelegate?
    
    // MARK: Properties
    private let service: CatsServices // API Call & CoreData
    
    private var cats: [Cat] = []
    // Interview suggestions:
    // tight coupling
    // use geter setter
    private var catsContainer: CatNSObjectsContainer? {
        didSet { // update cats
            self.cats = catsContainer!.cats
        }
    }
    
    // MARK: Init
    init(service: CatsServices) { self.service = service }
    
    func start() {
        service.fetchSavedCats {
            [weak self]
            (catsNSObjectArray, error) in
            guard let sSelf = self,
                  let catsNSObjectArray = catsNSObjectArray as? [NSManagedObject] else {
                return
            }
            let catContainer = CatNSObjectsContainer(catsNSManagedObjects: catsNSObjectArray)
            sSelf.catsContainer = catContainer
        }
    }
    
}

// MARK: - Network
extension CatsVM {
    private func getNewCat() {
        self.viewDelegate?.hud(show: true)
        service.fetchCat {
            [weak self]
            (cat, error) in
            guard let sSelf = self else { return }
            
            // you can write a show error function
            // and make these if elses like Sixt code challenge on WaitingVM class
            
            
            if let error = error {
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.showError(errorMessage: error.localizedDescription)
                }
                return
            }
            
            if let cat = cat as? Cat {
                DispatchQueue.main.async {
                    sSelf.saveNewCat(cat: cat)
                    sSelf.viewDelegate?.updateScreen()
                    sSelf.viewDelegate?.hud(show: false)
                }
                return
            }
            DispatchQueue.main.async {
                sSelf.viewDelegate?.showError(errorMessage: "Some Errors when communicating with the server occured!")
            }
            
        }
    }
}

// MARK: - Core Data
extension CatsVM {
    
    private func saveNewCat(cat: Cat) {
        service.save(cat: cat) {
            [weak self]
            (error) in
            guard let sSelf = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    sSelf.viewDelegate?.showError(errorMessage: error.localizedDescription)
                }
                return
            }
            
            sSelf.refreshView()
        }
    }
    
    func remove(at index: Int?) {
        
        guard let row = index,
              let catNSManagedObj = catsContainer?.catsNSManagedObjects[row] else { return }
        
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
                sSelf.refreshView()
            }
        }
        
    }
}

// MARK: - ViewModelType
extension CatsVM: CatsViewModelType {
    
    func numberOfItems() -> Int {
        cats.count
    }
    
    func itemFor(row: Int) -> UITableViewCell {
        // Interview suggestions:
        // why they're not in VC?
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "catID")
        let catViewData = CatViewData(cat: cats[row])
        cell.textLabel?.text = catViewData._id
        cell.detailTextLabel?.text = catViewData.createdAt
        return cell
    }
    
    func add() {
        getNewCat()
        viewDelegate?.updateScreen()
    }
    
    func delete() {
        let row = self.viewDelegate?.selectedCatRow()
        self.remove(at: row)
    }
    
    func didSelectRow(_ row: Int, from controller: UIViewController) {
        print("Cat in \(row) selected")
        didSelect(cat: cats[row], from: controller)
    }
    
    func refreshView() {
        start() // to refresh arrays
        viewDelegate?.updateScreen()
    }
}

// MARK: - ViewModelCoordinator
extension CatsVM: CatsViewModelCoordinatorDelegate {
    func didSelect(cat: Cat, from controller: UIViewController) {
        coordinatorDelegate?.didSelect(cat: cat,
                                       from: controller)
        // It'll open CatDetail VC
    }
}
