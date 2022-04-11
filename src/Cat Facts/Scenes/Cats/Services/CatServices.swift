//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import CoreData

class CatsServices {
    
    private let apiClient: Network
    private let coreDataManager: Storage
    
    // MARK: Init
    init(apiClient: Network, coreDataManager: Storage) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
    }
}

// MARK:- API Call
extension CatsServices {
    func fetchCat(completionHandler: @escaping (Any?, Error?) -> ()){
        apiClient.fetch { (result) in
            switch result {
            case .success(let cat):
                completionHandler(cat, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}

// MARK:- Core Data
extension CatsServices {
    func save(cat: Cat , completionHandler: @escaping (Error?) -> ()) {
        
        coreDataManager.save(object: cat) { (result) in
            switch result {
            case .success(_):
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    func fetchSavedCats(completionHandler: @escaping ([Any]?, Error?) -> ()) {
        coreDataManager.fetch { (result) in
            switch result {
            case .success(let cats):
                completionHandler(cats, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func delete(cat: NSManagedObject, completionHandler: @escaping (Bool, Error?) -> ()) {
        coreDataManager.delete(object: cat) { (result) in
            switch result {
            case .success(_):
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
}
