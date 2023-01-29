//
//  SecondViewController.swift
//  ExTimerView
//
//  Created by kant on 2023/01/26.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testView = TestView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        testView.alpha = 0.0
        self.view.addSubview(testView)
        
        UIView.animate(withDuration: 3.0) {
            testView.alpha = 1.0
        } completion: { _ in
            testView.configureTimer()
        }
    }
}
