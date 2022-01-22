//
//  ViewController.swift
//  ExLocalizedError
//
//  Created by Kant on 2022/01/22.
//

import UIKit

// Error 준수 타입 정의
enum RegisterError: Error {
    case invalidEmail
    case invalidPhoneNumber
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print(RegisterError.invalidEmail.localizedDescription)
    }
}

// localizedDescription 재정의 > LocalizedError 준수, errorDescription 연산 프로퍼티 정의
extension RegisterError: LocalizedError {
     public var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("Description of invalid email address", comment: "Invalid Email")

        case .invalidPhoneNumber:
            return NSLocalizedString("Description of invalid phone number", comment: "Invalid PhoneNumber")
        }
    }
}

