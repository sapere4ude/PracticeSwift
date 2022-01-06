//
//  ViewController.swift
//  ExStringTest
//
//  Created by Kant on 2021/12/22.
//

import UIKit

class ViewController: UIViewController {

    let str = "테스트 텍스트 입니다"
    let search = "텍스트"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        let range: Range<String.Index> = str.range(of: search)!
        let location : Int = str.distance(from: str.startIndex, to: range.lowerBound)
        let length : Int = search.count
                
        print("loc \(location), len \(length)")
    }
}

