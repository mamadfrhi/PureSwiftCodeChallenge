//
//  cat.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

protocol CatViewDataType {
    var _id: String { get }
    var text: String { get }
    var createdAt: String { get }
}

struct Cat: CatViewDataType, Decodable {
    var _id: String
    let text: String
    let createdAt: String
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
        if let isoDate = formatter.date(from: isoString) {
            // normal
            formatter.dateFormat = "yyyy-MM-dd"
            let stringDate = formatter.string(from: isoDate)
            return stringDate
        }
        return formatter.string(from: Date())
        // if data conversion failed, return today's date
    }
    
    private let cat: Cat
    
    init(cat: Cat) { self.cat = cat }
    
}
