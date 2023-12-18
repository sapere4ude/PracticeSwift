//
//  SecondViewController.swift
//  ExCoordinator
//
//  Created by Kant on 12/18/23.
//

import UIKit

class SecondViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second"
        view.backgroundColor = .systemBlue
    }
}
