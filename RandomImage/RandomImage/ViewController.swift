//
//  ViewController.swift
//  RandomImage
//
//  Created by Kant on 5/4/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private lazy var clickButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let viewModel = RequestViewModel()
    private let input: PassthroughSubject<RequestViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .toggleButton(let isEnabled):
                    self?.clickButton.isEnabled = isEnabled
                case .fetchDidSucceed(let data):
                    self?.displayRandomImage(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(clickButton)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            clickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            clickButton.widthAnchor.constraint(equalToConstant: 200),
            clickButton.heightAnchor.constraint(equalToConstant: 70),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc func didTapButton() {
        input.send(.refreshButtonDidTap)
    }
    
    private func displayRandomImage(_ data: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
}
