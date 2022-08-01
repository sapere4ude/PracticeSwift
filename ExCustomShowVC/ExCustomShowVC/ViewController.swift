//
//  ViewController.swift
//  ExCustomShowVC
//
//  Created by Kant on 2022/07/30.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnAction(_ sender: Any) {
//        let vc = BottomToTopVC()
//        let vc = TopToBottomVC()
        let vc = LeftToRightVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

