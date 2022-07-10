//
//  Polygon.swift
//  ExProtocol
//
//  Created by kant on 2022/07/03.
//

import Foundation

protocol Polygon {
    func getArea(length: Int, breadth: Int)
}

class Rectangle: Polygon {
    func getArea(length: Int, breadth: Int) {
        print("Area of the rectangle: ", length * breadth)
    }
}
