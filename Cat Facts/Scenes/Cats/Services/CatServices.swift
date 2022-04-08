//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class CatsServices {

    let apiClient: ApiClient

    // MARK: - Init
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func fetchCat() {
        apiClient.getCat { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
