//
//  DataItem.swift
//  ExSwiftData
//
//  Created by Kant on 11/25/23.
//

import Foundation
import SwiftData

@Model
class DataItem: Identifiable {
    
    var id: String
    var name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    
}
