//
//  MultipleProtocols.swift
//  ExProtocol
//
//  Created by kant on 2022/07/03.
//

import Foundation

protocol Sum {
    func addition()
}

protocol Multiplication {
    func product()
}

// confirm class to two protocols
class Calculate: Sum, Multiplication {
    
    var num1 = 0
    var num2 = 0
    
    func addition() {
        let result1 = num1 + num2
        print("Sum:", result1)
    }
    
    func product() {
        let result2 = num1 * num2
        print("Product:", result2)
    }
}
