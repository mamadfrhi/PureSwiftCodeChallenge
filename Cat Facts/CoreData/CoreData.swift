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
    func delete(object: Any, completion: @escaping (Result<Bool, Error>) -> ())
    func fetch(completion: @escaping (Result<[Any], Error>) -> ())
}

class CoreDataManager: LocalCRUD {
    func fetch(completion: @escaping (Result<[Any], Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.noAppDelegate))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(object: Any?, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.noAppDelegate))
            return
        }
        guard let catObject = object as? Cat else {
            completion(.failure(CoreDataError.coreDataSave))
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext // TODO: move from Appdelegate to another class
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
    
    func delete(object: Any, completion: @escaping (Result<Bool, Error>) -> ()) {
        print("I'm in core data class")
    }
    
}
struct CoreDataError {
    static let noAppDelegate = NSError(domain: "No App Delegate", code: 1, userInfo: nil)
    static let coreDataSave = NSError(domain: "Something wrong happened while saving the cat locally.", code: 1, userInfo: nil)
}


// a class which converts cat simple object
// to dataType to save
// to cat to pass
