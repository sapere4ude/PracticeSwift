//
//  HomeView.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func displayWelcomeMessage(_ message: String)
}

final class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    
    private let messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func displayWelcomeMessage(_ message: String) {
        messageLabel.text = message
    }
}
