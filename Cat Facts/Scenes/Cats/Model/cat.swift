//
//  cat.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation


struct Cat: CatViewDataType, Decodable {
    var _id: String
    let text: String
    let createdAt: String
}

protocol CatViewDataType {
    
    var _id: String { get }
    var text: String { get }
    var createdAt: String { get }
    
}

struct CatViewData: CatViewDataType {
    
    var _id: String {
        return cat._id
    }
    
    var text: String {
        return cat.text
    }
    
    var createdAt: String {
        // iso
        let isoString = cat.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let isoDate = formatter.date(from: isoString)! // TODO: Take care of force unwrapping
        // normal
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: isoDate)
        return stringDate
    }
    
    private let cat: Cat
    
    init(cat: Cat) {
        self.cat = cat
    }
    
}
