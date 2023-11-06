//
//  ViewController.swift
//  ExWeakReference
//
//  Created by Kant on 11/6/23.
//

import UIKit

class ViewController: UIViewController {
    
    let openButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("open secondVC", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        openButton.addTarget(self, action: #selector(presentTimerVC), for: .touchUpInside)
    }
    
    func configureUI() {
        view.addSubview(openButton)
        NSLayoutConstraint.activate([
            openButton.widthAnchor.constraint(equalToConstant: 200),
            openButton.heightAnchor.constraint(equalToConstant: 150),
            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    func presentTimerVC() {
        //let timerVC = TimerViewController()
        let secondVC = SecondViewController()
        secondVC.modalPresentationStyle = .formSheet
        present(secondVC, animated: true)
    }
    
    
}

