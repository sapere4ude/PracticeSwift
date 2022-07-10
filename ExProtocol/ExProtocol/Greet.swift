//
//  Greet.swift
//  ExProtocol
//
//  Created by kant on 2022/07/03.
//

import Foundation

protocol Greet {
    
    // blueprint of a property
    var name: String { get }
    
    // blueprint of a method
    func message()
}

class Employee: Greet {
    var name: String = "Kant"
    
    func message() {
        print("Hello Protocol", name)
    }
}
