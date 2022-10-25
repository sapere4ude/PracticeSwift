//
//  LSP.swift
//  SOLID
//
//  Created by Kant on 2022/10/25.
//

// LSP(Liskov Substitution Principle) - 리스코프 치환 원칙

import Foundation

// Bad case
//class Rectangle {
//    var width: Float = 0
//    var height: Float = 0
//
//    var area: Float {
//        return width * height
//    }
//}
//
//class Square: Rectangle {
//    override var width: Float {
//        didSet {
//            height = width
//        }
//    }
//}
//
//func printArea(of rectangle: Rectangle) {
//    rectangle.width = 6
//    rectangle.height = 3
//    print(rectangle.area)
//}
//
//
//let rectangle = Rectangle()
//printArea(of: rectangle) // 18
//
//let square = Square()
//printArea(of: square) // 36


// cf. Expressions are not allowed at the top level 관련 참고 블로그
// https://plcprogrammer-dy.tistory.com/32


// Good case
//protocol Shape {
//    var area: Float { get }
//}
//
//class Rectangle: Shape {
//    let width: Float
//    let height: Float
//
//    var area: Float {
//        return width * height
//    }
//
//    init(width: Float, height: Float) {
//        self.width = width
//        self.height = height
//    }
//}
//
//class Square: Shape {
//    let length: Float
//
//    var area: Float {
//        return length * length
//    }
//
//    init(length: Float) {
//        self.length = length
//    }
//}
