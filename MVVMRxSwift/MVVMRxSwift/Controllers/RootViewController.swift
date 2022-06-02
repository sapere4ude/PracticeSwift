//
//  RootViewController.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: Configures
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
