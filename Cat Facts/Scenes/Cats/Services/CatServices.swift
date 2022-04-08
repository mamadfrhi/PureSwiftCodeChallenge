//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class CatsServices {

    private let apiClient: ApiClient

    // MARK: - Init
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func fetchCat(completionHandler: @escaping (Cat?, Error?) -> ()){ // TODO: can I use an error struct instead of String? ?
        apiClient.getCat { (result) in
            switch result {
            case .success(let cat):
                completionHandler(cat, nil)
            case .failure(let error): // TODO: make more concise error handling
                completionHandler(nil, error)
            }
        }
    }
}
