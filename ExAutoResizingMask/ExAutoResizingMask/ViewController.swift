//
//  ViewController.swift
//  ExAutoResizingMask
//
//  Created by eileenyou on 2022/05/12.
//

import UIKit

class ViewController: UIViewController {

    lazy var superView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        view.backgroundColor = .systemYellow
        return view
    }()
    
    lazy var subView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = .systemGreen
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        superView.center = view.center
        self.view.addSubview(superView)
        superView.addSubview(subView)
        
        // autoresizingMask 코드 여부로 subView의 크기, 위치 조정이 가능하다.
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //subView.autoresizingMask = [.flexibleLeftMargin]
        
        UIView.animate(withDuration: 2.5) {
            self.superView.bounds.size = CGSize(width: 300, height: 300)
        }
    }
}

