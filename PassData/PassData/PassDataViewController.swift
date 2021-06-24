//
//  PassDataViewController.swift
//  PassData
//
//  Created by Kant on 2021/06/24.
//

import UIKit

protocol passDataDelegate {
    func passData(text: String!)
}

class PassDataViewController: UIViewController {

    @IBOutlet weak var inputText: UITextField!
    
    // 1. 델리게이트를 사용한 데이터 전달
    var delegate: passDataDelegate?
    
    // 2. Completion Handler를 사용한 데이터 전달
    var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputText.text = ""
    }
    
    @IBAction func passData(_ sender: Any) {
        self.delegate?.passData(text: "\(String(describing: inputText))")
        self.completion?("목요일 오후 10:45")
//        let main = self.presentingViewController
//        main?.reloadInputViews()
        self.dismiss(animated: true, completion: nil)
    }
    
}
