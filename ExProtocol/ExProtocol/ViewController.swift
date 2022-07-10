//
//  ViewController.swift
//  ExProtocol
//
//  Created by kant on 2022/07/02.
//

import UIKit

// 참조하여 확인한 곳
// https://www.programiz.com/swift-programming/protocols

class ViewController: UIViewController {

    var employee1 = Employee()
    
    var r1 = Rectangle()
    
    var calc1 = Calculate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employee1.message()
        r1.getArea(length: 5, breadth: 10)
        
        calc1.num1 = 5
        calc1.num2 = 10
        calc1.addition()
        calc1.product()
        
    }


}

