//
//  ViewController.swift
//  ExFloatingView
//
//  Created by kant on 2023/02/28.
//

import UIKit

protocol FloatingBannerAnimate where Self: UIViewController {
    func floatingBannerAnimate(vc: UIViewController, v: UIView)
}

extension FloatingBannerAnimate {
    func floatingBannerAnimate(vc: UIViewController, v: UIView) {
        // 뷰의 높이 제약 조건 추가
        let heightConstraint = v.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.isActive = true

        // 뷰의 y 위치 제약 조건 추가
        let topConstraint = v.topAnchor.constraint(equalTo: vc.view.bottomAnchor)
        topConstraint.isActive = true
        let leadingConstraint = v.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor)
        leadingConstraint.isActive = true
        let trailingConstraint = v.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        trailingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            topConstraint.constant = -100 // y 위치를 위로 이동시키기 위해 음수값으로 변경
            vc.view.layoutIfNeeded() // 변경된 제약 조건을 적용하여 뷰를 업데이트
        }
    }
}

class ViewController: UIViewController, FloatingBannerAnimate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height + 200, width: self.view.bounds.width, height: 200))
        myView.backgroundColor = .red
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myView)
        
        floatingBannerAnimate(vc: self, v: myView)
    }
}

protocol BannerRepository {
    
}

class MyView: UIView {
    override init(frame:CGRect){
        super.init(frame: frame)
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
