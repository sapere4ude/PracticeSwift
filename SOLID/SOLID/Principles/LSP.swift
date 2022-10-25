//
//  LSP.swift
//  SOLID
//
//  Created by Kant on 2022/10/25.
//

// LSP(Liskov Substitution Principle) - 리스코프 치환 원칙

import Foundation

// Bad case
class Rectangle {
    var width: Float = 0
    var height: Float = 0
    
    var area: Float {
        return width * height
    }
}

class Square: Rectangle {
    override var width: Float {
        didSet {
            height = width
        }
    }
}

func printArea(of rectangle: Rectangle) {
    rectangle.width = 6
    rectangle.height = 3
    print(rectangle.area)
}


let rectangle = Rectangle()
printArea(of: rectangle) // 18

let square = Square()
printArea(of: square) // 36

