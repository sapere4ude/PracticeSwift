//
//  OCP.swift
//  SOLID
//
//  Created by Kant on 2022/10/25.
//

// OCP(Open-Closed Principle) - 개방, 폐쇄 원칙

import Foundation

// Bad case
//class Dog {
//    func makeSound() {
//        print("멍멍")
//    }
//}
//
//class Cat {
//    func makeSound() {
//        print("야옹")
//    }
//}
//
//class Zoo {
//    var dogs: [Dog] = [Dog(), Dog(), Dog()]
//    var cats: [Cat] = [Cat(), Cat(), Cat()]
//
//    func makeAllSounds() {
//        dogs.forEach {
//            $0.makeSound()
//        }
//
//        cats.forEach {
//            $0.makeSound()
//        }
//    }
//}

// Good case
protocol Animal {
    func makeSound()
}

class Dog: Animal {
    func makeSound() {
        print("멍멍")
    }
}

class Cat: Animal {
    func makeSound() {
        print("야옹")
    }
}

class Zoo {
    var animals: [Animal] = []
    
    func makeAllSounds() {
        animals.forEach {
            $0.makeSound()
        }
    }
}
