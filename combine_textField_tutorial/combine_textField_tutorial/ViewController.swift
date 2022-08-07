//
//  ViewController.swift
//  combine_textField_tutorial
//
//  Created by Kant on 2022/08/07.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var myBtn: UIButton!
    
    var viewModel: MyViewModel!
    
    private var mySubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = MyViewModel()
        
        /*
         case1, case2 의 경우
         텍스트필드에서 나가는 이벤트를 뷰모델의 프로퍼티가 구독
         **/
        
        // csae1
        passwordTextField
            .myTextPublisher
            // receive 를 통해 어디서 받을지 선택
            .receive(on: RunLoop.main)
            // KVO 방식으로 구독이 완료된 상태 (viewModel에 있는 passwordInput으로 값이 전달 되는것)
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        // case2
        passwordConfirmTextField
            .myTextPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        /*
         버튼이 뷰모델의 퍼블리셔를 구독
         **/
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: RunLoop.main)
            // 구독
            .assign(to: \.isValid, on: myBtn)
            .store(in: &mySubscriptions)
    }
}

extension UITextField {
    var myTextPublisher: AnyPublisher<String, Never> {
        // textDidChangeNotification 가 들어왔을때 이벤트를 발산하는 역할을 함
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            // UITextField 가져옴
            .compactMap { $0.object as? UITextField }
            // String 가져옴
            .map { $0.text ?? "" }
            .print() // receive value 라는 이름으로 받을 수 있다
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    // 즉, get을 통해 true, false 값을 알게되고 이후에 set으로 넘어가 이것저것 실행되는 구조
    var isValid: Bool {
        get {
            backgroundColor == .red
        }
        set {
            backgroundColor = newValue ? .red : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
