//
//  CoreData.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import CoreData
import UIKit

protocol Storage: class {
    func save(object: Any?, completion: @escaping (Result<Bool, Error>) -> ())
    func delete(object: Any?, completion: @escaping (Result<Bool, Error>) -> ())
    func fetch(completion: @escaping (Result<[Any], Error>) -> ())
}

class CoreDataManager: Storage {
    
    // TODO: write an init and inject CoreDataContainer
    
    private let entityName = "Cat"
    
    func fetch(completion: @escaping (Result<[Any], Error>) -> ()) {
        let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch {
            completion(.failure(CoreDataError.coreDataFetch))
        }
    }
    
    func save(object: Any?, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let catObject = object as? Cat else {
            completion(.failure(CoreDataError.coreDataSave))
            return
        }
        
        let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            completion(.failure(CoreDataError.coreDataSave))
            return
        }
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
    static let coreDataFetch = NSError(domain: "Something wrong happened while fetching the cat locally.", code: 10, userInfo: nil)
    static let coreDataSave = NSError(domain: "Something wrong happened while saving the cat locally.", code: 11, userInfo: nil)
    static let coreDataDelete = NSError(domain: "Something wrong happened while deleting the cat locally.", code: 12, userInfo: nil)
}
