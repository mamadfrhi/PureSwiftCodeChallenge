//
//  CatNSManagedObjectWrapper.swift
//  Cat Facts
//
//  Created by iMamad on 4/9/22.
//

import CoreData

class CatCoreDataConvertor {
    
    // TODO: write a wrapper for NSManagedObject
    // Interview suggestions:
    // why it's here?
    // find a solution
    func giveMeCats(from catsNSManagedObjects: [NSManagedObject]) -> [Cat] {
        var cats : [Cat] = []
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
        return cats
    }
}
