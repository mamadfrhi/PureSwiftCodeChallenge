//
//  CoreData.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import CoreData
import UIKit

protocol LocalCRUD { // it can be named CoreDataActions too
    func save(object: Any?, completion: @escaping (Result<Bool, Error>) -> ())
    func delete(object: Any?, completion: @escaping (Result<Bool, Error>) -> ())
    func fetch(completion: @escaping (Result<[Any], Error>) -> ())
}

class CoreDataManager: LocalCRUD {
    func fetch(completion: @escaping (Result<[Any], Error>) -> ()) {
        let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cat")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(object: Any?, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let catObject = object as? Cat else {
            completion(.failure(CoreDataError.coreDataSave))
            return
        }
        
        let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cat", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        task.setValue(catObject._id,
                      forKey: "id")
        task.setValue(catObject.createdAt,
                      forKey: "createdAt")
        task.setValue(catObject.text,
                      forKey: "text")
        do {
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(object: Any?, completion: (Result<Bool, Error>) -> ()) {
        guard let nsManagedObject = object as? NSManagedObject else {
            completion(.failure(CoreDataError.coreDataDelete))
            return
        }
        let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
        managedContext.delete(nsManagedObject)
        do {
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
}
struct CoreDataError {
    static let noAppDelegate = NSError(domain: "No App Delegate", code: 1, userInfo: nil)
    static let coreDataSave = NSError(domain: "Something wrong happened while saving the cat locally.", code: 1, userInfo: nil)
    static let coreDataDelete = NSError(domain: "Something wrong happened while deleting the cat locally.", code: 1, userInfo: nil)
}


// a class which converts cat simple object
// to entity
// why? to get rid of lines 36-43
// it makes CoreDataManager class even more reuseable.
