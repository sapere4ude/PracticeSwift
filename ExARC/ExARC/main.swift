//
//  main.swift
//  ExARC
//
//  Created by Kant on 2022/02/27.
//

// ARC 문법 자료: https://jusung.gitbook.io/the-swift-language-guide/language-guide/23-automatic-reference-counting

import Foundation

// ARC in Action
//class Person {
//    let name: String
//    init(name: String) {
//        self.name = name
//        print("\(name) is being initialized")
//    }
//    deinit {
//        print("\(name) is being deinitialized")
//    }
//}
//
//var reference1: Person?
//var reference2: Person?
//var reference3: Person?
//
//reference1 = Person(name: "kant")
//reference2 = reference1
//reference3 = reference1
//
//reference1 = nil
//reference2 = nil
//
//reference3 = nil

// Strong Reference Cycles Between Class Instances
class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    var apartment: Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    weak var tenant: Person?
    deinit {
        print("\(unit) is being deinitialized")
    }
}

var kant: Person?
var lotteTower: Apartment?

kant = Person(name: "kant yoo")
lotteTower = Apartment(unit: "3A")

kant?.apartment = lotteTower
lotteTower?.tenant = kant

kant = nil
lotteTower = nil
