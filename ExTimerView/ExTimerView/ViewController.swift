//
//  ViewController.swift
//  ExTimerView
//
//  Created by kant on 2023/01/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testView = TestView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        self.view.addSubview(testView)
    }
}

