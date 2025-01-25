//
//  LoginView.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    func showLoginSuccess()
    func showLoginFailure(error: String)
}

final class LoginViewController: UIViewController, LoginViewProtocol {
    var presenter: LoginPresenterProtocol?
    
    private let userNameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        userNameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .red
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [userNameTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 150),
            loginButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 50)
        ])
    }
    
    @objc
    private func didTapLogin() async {
        guard let userName = userNameTextField.text,
              let password = passwordTextField.text else { return }
        await presenter?.login(userName: userName, password: password)
    }
    
    func showLoginSuccess() {
        print("Login Successful")
    }
    
    func showLoginFailure(error: String) {
        print("Login Failed: \(error)")
    }
}

