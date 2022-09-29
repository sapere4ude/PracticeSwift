//
//  ProcViewController.swift
//  ExCustomDelegate2
//
//  Created by Kant on 2021/11/13.
//

import UIKit

protocol ProcViewDelegate: AnyObject {
    func didBtnClicked(data: String)
}

class ProcViewController: UIViewController {
    var procViewDelegate: ProcViewDelegate?

    @IBOutlet weak var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // #2
    @IBAction func btnClicked(_ sender: UIButton) {
        procViewDelegate?.didBtnClicked(data: "procViewDelegate를 사용한 VC로 값 전달")
        self.dismiss(animated: true)
    }
}
