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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        let date = dateFormatter.date(from: cat.createdAt) ?? Date() // TODO: Not a good idea
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    private let cat: Cat
    
    init(cat: Cat) {
        self.cat = cat
    }

}
