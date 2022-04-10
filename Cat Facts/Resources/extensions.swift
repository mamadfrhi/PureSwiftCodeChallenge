//
//  extensions.swift
//  Cat Facts
//
//  Created by iMamad on 4/10/22.
//

import Foundation

extension StringProtocol {
    var firstLowercased: String { return prefix(1).lowercased() + dropFirst() }
}
