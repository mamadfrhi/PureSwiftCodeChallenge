//
//  CatNSManagedObjectWrapper.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import CoreData

struct CatCoreDataConvertor {
    
    func giveMeCats(from catsNSManagedObjects: [NSManagedObject]) -> [Cat] {
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
}
