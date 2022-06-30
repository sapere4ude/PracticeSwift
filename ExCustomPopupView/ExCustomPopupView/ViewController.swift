//
//  ViewController.swift
//  ExCustomPopupView
//
//  Created by Kant on 2022/06/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func btnAction(_ sender: Any) {
        PopupView.shared.show(vc: self)
//        VodPodUpView.shared.show(vc: self)
    }
}

