//
//  ViewController.swift
//  ExTimerView
//
//  Created by kant on 2023/01/26.
//

import UIKit

class ViewController: UIViewController {

    let testView = TimerTestView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testView.alpha = 0.0
        self.view.addSubview(testView)
        
        UIView.animate(withDuration: 3.0) {
            self.testView.alpha = 1.0
        } completion: { _ in
            self.testView.configureTimer()
        }
    }
}

