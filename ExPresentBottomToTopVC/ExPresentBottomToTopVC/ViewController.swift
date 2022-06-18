//
//  ViewController.swift
//  ExPresentBottomToTopVC
//
//  Created by Kant on 2022/06/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        let button = UIButton(type: .system)
        button.setTitle("Open Filter", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        let bottomSheetVC = BottomSheetViewController()
        // 1
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        // 2
        self.present(bottomSheetVC, animated: false, completion: nil)
    }


}

