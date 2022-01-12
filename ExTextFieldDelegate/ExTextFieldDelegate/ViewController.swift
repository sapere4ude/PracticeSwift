//
//  ViewController.swift
//  ExTextFieldDelegate
//
//  Created by Kant on 2022/01/12.
//

// UITextFieldDelegate 정리

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    // 텍스트 필드를 터치를 시작함과 동시에 호출되는 메서드.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // ShouldBeginEditing이 호출된 이후에 실행되는 메서드로 수정하는 역할로 사용됨.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // 현재 입력되고 있는 텍스트 필드가 아닌 다른 텍스트 필드로 터치할 경우 불리는 메서드.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 텍스트 필드가 이동된 이후 실행되어야 할 코드를 작성하는 메서드.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // 키보드 우측 하단의 Return 을 누를 경우 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 입력값이 실시간으로 생성,삭제될때마다 호출되는 메서드. 이를 통해 텍스트 필드의 길이를 제한한다.
    // 추가적인 설명은 노션에 range 로 검색해서 range.location, range.length 설명을 참고할 것
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // 텍스트 필드 자체에 Clear 버튼을 넣어줄 수 있다. 스트리보드 > Attribute Inspector > Clear Button 을 참고할 것.
    // Clear Button 을 통해 모든 내용이 지워졌을때, 이 메소드가 실행된다.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

