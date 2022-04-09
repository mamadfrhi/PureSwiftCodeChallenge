//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation
import CoreData

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
    
    func fetchLocalCats(completionHandler: @escaping ([Any]?, Error?) -> ()) {
        coreDataManager.fetch { (result) in
            switch result {
            case .success(let cats):
                print(cats)
                completionHandler(cats, nil)
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
    }
}

protocol CatNSObjectWrapperType {
    var catsNSManagedObjects: [NSManagedObject] { get }
    var cats: [Cat]? { get }
}

struct CatNSManagedObjectWrapper: CatNSObjectWrapperType {
    var cats: [Cat]? {
        var cats : [Cat] = []
        for nsManagedObj in catsNSManagedObjects {
            let id = String(describing: nsManagedObj.value(forKey: "id"))
            let text = String(describing: nsManagedObj.value(forKey: "text"))
            let createdAt = String(describing: nsManagedObj.value(forKey: "createdAt"))
            
            let cat = Cat(_id: id, text: text, createdAt: createdAt)
            
            cats.append(cat)
        }
        return cats
    }
    
    var catsNSManagedObjects: [NSManagedObject]
    
    init(catsNSObjects: [NSManagedObject]) {
        self.catsNSManagedObjects = catsNSObjects
    }
}
