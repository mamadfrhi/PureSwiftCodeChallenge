//
//  CoreDataContainer.swift
//  Cat Facts
//
//  Created by iMamad on 4/10/22.
//

import CoreData

class CoreDataContainer {
    
    static let shared = CoreDataContainer() // Singleton
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cat_Facts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


// TODO: Take care of fatalErrors
// idea: inject this class from Coordinator to the CatsViewModel class
// and handle errors in the viewModel
// then init CoreDataManager and inject to services
