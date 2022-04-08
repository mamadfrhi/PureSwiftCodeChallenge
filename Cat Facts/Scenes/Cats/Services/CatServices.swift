//
//  CatServices.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class CatsServices {
    // TODO: APIClient must be abstract not a concrete type
    let apiClient: ApiClient
    var coordinateDelegate: Coordinator?
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}
