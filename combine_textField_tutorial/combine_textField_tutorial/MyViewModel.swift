//
//  MyViewModel.swift
//  combine_textField_tutorial
//
//  Created by Kant on 2022/08/07.
//

import Foundation
import Combine

class MyViewModel {
    // 구독할 수 있도록 도와주는 것
    // published 어노테이션을 통해 구독이 가능하도록 설정
    @Published var passwordInput: String = "" {
        didSet {
            print("MyViewModel > passwordInput: \(passwordInput)")
        }
    }
    @Published var passwordConfirmInput: String = "" {
        didSet {
            print("MyViewModel > passwordConfirmInput: \(passwordConfirmInput)")
        }
    }
    
    // 들어온 퍼블리셔들의 값 일치 여부를 반환하는 퍼블리셔
    lazy var isMatchPasswordInput: AnyPublisher<Bool,Never> = Publishers // error를 발산하는게 아니라면 Never 를 넣어준다
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map({(password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
}
