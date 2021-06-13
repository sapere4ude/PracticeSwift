//
//  ViewController.swift
//  Ch02_Button
//
//  Created by Kant on 2021/06/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 버튼 인스턴스 생성
        let btn = UIButton(type: .system)
        
        // 2. 버튼 영역 정의
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        
        btn.center = CGPoint(x: self.view.frame.size.width / 2, y: 100)
        
        // 3. 버튼 속성 정의
        btn.setTitle("테스트 버튼", for: .normal)
        
        // 4. 버튼을 루트뷰에 추가
        self.view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(btnClcik(_:)), for: .touchUpInside)
    }
    
    @objc func btnClcik(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.setTitle("클릭되었습니다.", for: .normal)
        }
    }


}

