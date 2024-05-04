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
    
    //private let requestAPI = RequestAPI()
    private let viewModel = RequestViewModel()
    private let input: PassthroughSubject<RequestViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .fetchDidFailed(let error):
                    //self?.
                case .fetchDidSucceed(data: <#T##Data#>)
                }
            }
    }
    
    func setupUI() {
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
//        requestAPI.getUrlRequest()
//            .sink { [weak self] completion in
//                if case .failure(let error) = completion {
//                    print(#fileID, #function, #line, "Error:", error)
//                }
//            } receiveValue: { [weak self] randomImage in
//                self?.displayRandomImage(randomImage)
//            }.store(in: &cancellables)
    }
    
    func displayRandomImage(_ data: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
}

class RequestViewModel {
    
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchDidFailed(error: Error)
        case fetchDidSucceed(data: Data)
        case toggleButton(isEnabled: Bool)
    }
    
    private let requestAPI: RequestAPI
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(requestAPI: RequestAPI = RequestAPI()) {
        self.requestAPI = requestAPI
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .refreshButtonDidTap:
                self?.handleGetUrlRequest()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetUrlRequest() {
        requestAPI.getUrlRequest()
            .sink { [weak self] completion in
                self?.output.send(.toggleButton(isEnabled: true))
                if case .failure(let error) = completion {
                    self?.output.send(.fetchDidFailed(error: error))
                }
            } receiveValue: { [weak self] data in
                self?.output.send(.fetchDidSucceed(data: data))
            }.store(in: &cancellables)
    }
}
