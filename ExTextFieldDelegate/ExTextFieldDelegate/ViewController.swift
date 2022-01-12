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
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 입력값이 실시간으로 생성,삭제될때마다 호출되는 메서드. 이를 통해 텍스트 필드의 길이를 제한한다.
    // 추가적인 설명은 노션에 range 로 검색해서 range.location, range.length 설명을 참고할 것
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        <#code#>
//    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

