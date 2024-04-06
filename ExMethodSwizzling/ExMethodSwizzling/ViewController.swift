//
//  ViewController.swift
//  ExMethodSwizzling
//
//  Created by Kant on 4/6/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.setTitle("클릭", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc
    func buttonClicked() {
        print(#function, "버튼이 클릭되었습니다.")
    }
}

extension UIButton {
    // 클래스 초기화 시 Method Swizzling 실행
    static let swizzleSendAction: Void = {
        let originalSelector = #selector(sendAction(_:to:for:))
        let swizzledSelector = #selector(swizzled_sendAction(_:to:for:))
        
        guard let originalMethod = class_getInstanceMethod(UIButton.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIButton.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    // Swizzling 대상이 되는 새로운 메서드
    @objc func swizzled_sendAction(_ action: Selector, to target: AnyObject?, for event: UIEvent?) {
        // 원하는 로직을 여기에 추가합니다. 예를 들어, 콘솔에 로그 출력
        print(#function, "\(self). 어떤 메서드에서 가져온건지? -> \(action)")
        
        // 원래의 메서드 호출
        swizzled_sendAction(action, to: target, for: event)
    }
}

// 앱 실행 시 Method Swizzling을 활성화합니다.
func enableMethodSwizzling() {
    _ = UIButton.swizzleSendAction
}

