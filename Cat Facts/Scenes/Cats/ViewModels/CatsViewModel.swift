//
//  CatsViewModel.swift
//  Cat Facts
//
//  Created by iMamad on 4/8/22.
//

import Foundation

class CatsViewModel {
    
    let serevice: CatsServices
    var coordinatorDelegate: Coordinator?
    
    init(service: CatsServices) {
        self.serevice = service
    }
}
