//
//  ISP.swift
//  SOLID
//
//  Created by Kant on 2022/10/26.
//

// ISP(Interface Segregation) - 인터페이스 분리 원칙

import Foundation

// Bad case
//protocol Shape {
//    var area: Float { get }
//    var length: Float { get }
//}
//
//class Square: Shape {
//    var width: Float
//    var height: Float
//
//    var area: Float {
//        return width * height
//    }
//
//    var length: Float {
//        return 0
//    }
//
//    init(width: Float, height: Float) {
//        self.width = width
//        self.height = height
//    }
//}
//
//class Line: Shape {
//    var pointA: Float
//    var pointB: Float
//
//    var area: Float {
//        return 0
//    }
//
//    var length: Float {
//        return pointA - pointB
//    }
//
//    init(pointA: Float, pointB: Float) {
//        self.pointA = pointA
//        self.pointB = pointB
//    }
//}

// Good case
protocol AreaCalculatbleShape {
    var area: Float { get }
}

protocol LengthCalculatableShape {
    var length: Float { get }
}

class Square: AreaCalculatbleShape {
    var width: Float
    var height: Float
    
    var area: Float {
        return width * height
    }
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

class Line: LengthCalculatableShape {
    var pointA: Float
    var pointB: Float
    
    var length: Float {
        return pointA - pointB
    }
    
    init(pointA: Float, pointB: Float) {
        self.pointA = pointA
        self.pointB = pointB
    }
}
