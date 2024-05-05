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
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
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
                case .fetchDidSucceed(let model):
                    self?.displayRandomImage(model) { isSuccess in
                        if isSuccess {
                            DispatchQueue.main.async {
                                self?.titleLabel.text = model.author
                            }
                        }
                    }
                case .fetchDidFailed(error: let error):
                    self?.titleLabel.text = error.localizedDescription
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        [titleLabel, imageView, clickButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),

            clickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            clickButton.widthAnchor.constraint(equalToConstant: 200),
            clickButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc func didTapButton() {
        input.send(.refreshButtonDidTap)
    }
    
    private func displayRandomImage(_ data: RequestModel, completion: @escaping (Bool) -> Void) {
        if let url = URL(string: data.download_url) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                        completion(true)
                    }
                }
            }.resume()
        } else {
            completion(false)
        }
    }
}
