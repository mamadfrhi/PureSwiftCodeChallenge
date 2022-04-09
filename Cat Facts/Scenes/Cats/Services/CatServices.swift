//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class CatsServices {
    
    private let apiClient: ApiClient
    private let coreDataManager: LocalCRUD
    
    // MARK: - Init
    init(apiClient: ApiClient, coreDataManager: LocalCRUD) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
    }
}
// MARK: - API Call
extension CatsServices {
    func fetchCat(completionHandler: @escaping (Cat?, Error?) -> ()){ // TODO: can I use an error struct instead of String? ?
        apiClient.getCat { (result) in
            switch result {
            case .success(let cat):
                completionHandler(cat, nil)
            case .failure(let error): // TODO: make more concise error handling
                completionHandler(nil, error)
            }
        }
    }
}
// MARK: - Core Data
extension CatsServices {
    func saveCat(cat: Cat , completionHandler: @escaping (Error?) -> ()) {
        
        coreDataManager.save(object: cat) { (result) in
            switch result {
            case .success(_):
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}
