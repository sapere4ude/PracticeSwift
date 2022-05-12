//
//  ViewController.swift
//  ExOpenUIViewCustom
//
//  Created by eileenyou on 2022/05/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // case1. File’s Owner의 Custom Class 사용시엔 init 생성자를 사용할 수 있는 이점이 있음
//        let sampleView = SampleView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        self.view.addSubview(sampleView)
        
        
        // case2. View의 Custom Class를 사용하는 경우
        let name = String(describing: SampleView2.self)
        
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else {
            return
        }
        guard let sampleView2 = loadedNib.first as? SampleView2 else { // // 타입 캐스팅이 SampleView2
            return
        }
        
        self.view.addSubview(sampleView2)
    }
}

