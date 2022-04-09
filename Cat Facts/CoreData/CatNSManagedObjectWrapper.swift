//
//  CatNSManagedObjectWrapper.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import CoreData

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
