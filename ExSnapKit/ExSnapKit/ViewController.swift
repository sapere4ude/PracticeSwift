//
//  ViewController.swift
//  ExSnapKit
//
//  Created by eileenyou on 2022/05/17.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    lazy var sampleView1: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    lazy var sampleView2: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var sampleView3: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(sampleView1)
        self.view.addSubview(sampleView2)
        self.view.addSubview(sampleView3)
        
        sampleView1.snp.makeConstraints {
            $0.width.equalTo(self.view)
            $0.height.equalTo(100)
            
            // inset test
            // $0.top.equalTo(self.view).inset(50)
            
            // offset test
            $0.top.equalTo(self.view).offset(50) // offset을 0으로 주게되면 디바이스 상단의 safe area를 무시하고 상태바 영역에 view가 그려지는 것을 확인할 수 있다.
        }
        
        sampleView2.snp.makeConstraints {
            $0.width.equalTo(self.view)
            $0.height.equalTo(100)
            
            $0.top.equalTo(self.sampleView1.snp.bottom).offset(100)
        }
        
        sampleView3.snp.makeConstraints {
            $0.top.equalTo(self.sampleView2.snp.bottom).offset(100)
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.bottom.equalToSuperview().offset(-50)
            
            // 이렇게도 사용 가능하다
            //$0.edges.equalToSuperview().inset(UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        }
    }
}

