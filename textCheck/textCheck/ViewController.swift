//
//  ViewController.swift
//  textCheck
//
//  Created by Kant on 2021/06/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordText.text = ""
        passwordText.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            if isValidLengthPassword(pwd: textField.text!) == false {
                print("@@@")
            }
            if isValidCharacterAndNumber(pwd: textField.text!) == false {
                print("###")
            }
            if isValidatePasswordSuccessive(pwd: textField.text!) == false {
                print("^ㅁ^")
            }
        }
        return true
    }
}

// 6자 미만 문자 입력시
func isValidLengthPassword(pwd: String) -> Bool {
    if pwd.count > 6 {
        return true
    } else {
         return false
    }
}

// 영문, 숫자 조합
func isValidCharacterAndNumber(pwd: String) -> Bool {
    let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{6,10}$"
    let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return predicate.evaluate(with: pwd)
}

// 동일한 문자/숫자를 3개 이상 사용
func isValidatePasswordSuccessive(pwd: String) -> Bool {
    
    let passwordRegEx = "(.)\\1\\1" // 동일한 한 글자(문자, 숫자)가 3번 중복
    
    if pwd.range(of: passwordRegEx, options: .regularExpression) != nil {
           return false
       } else {
           return true
       }

}
