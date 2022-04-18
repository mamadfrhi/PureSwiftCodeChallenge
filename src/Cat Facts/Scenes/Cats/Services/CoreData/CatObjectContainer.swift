//
//  CoreData.swift
//  Cat Facts
//
//  Created by iMamad on 4/15/22.
//

import CoreData
import Foundation

class CatNSObjectsContainer {
    
    // MARK: Properties
    var catsNSManagedObjects: [NSManagedObject] = []
    var cats: [Cat] = []
    
    // MARK: Init
    init(catsNSManagedObjects: [NSManagedObject]) {
        self.catsNSManagedObjects = catsNSManagedObjects
        convertCatsToNSManagedObjects()
    }
    // TODO: Change name of function
    private func convertCatsToNSManagedObjects() {
        
        for nsManagedObj in catsNSManagedObjects {
            // unwrap
            if let id = nsManagedObj.value(forKey: "id"),
               let text = nsManagedObj.value(forKey: "text"),
               let createdAtObj = nsManagedObj.value(forKey: "createdAt") {
                // to string
                let id = "\(id)"
                let text = "\(text)"
                let cratedAt = "\(createdAtObj)"
                
                let cat = Cat(_id: id,
                              text: text,
                              createdAt: cratedAt)
                
                cats.append(cat)
            }
        }
    }
}


////#1
//protocol CoreDataWorkerProtocol {
//    associatedtype EntityType
//
//    func get(with predicate: Predicate?, sortDescriptors: [SortDescriptor]?,
//             completion: @escaping (Result<[EntityType]>) -> Void)
//
//    //...
//}
//
////#2
//class CoreDataWorker<ManagedEntity, Entity>: CoreDataWorkerProtocol where
//    ManagedEntity: NSManagedObject,
//    ManagedEntity: ManagedObjectProtocol,
//    Entity: ManagedObjectConvertible  { }
