//
//  RequestViewModel.swift
//  RandomImage
//
//  Created by Kant on 5/4/24.
//

import Combine
import Foundation

class RequestViewModel {
    
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchDidFailed(error: Error)
        case fetchDidSucceed(model: RequestModel)
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
            } receiveValue: { [weak self] requestModel in
                self?.output.send(.fetchDidSucceed(model: requestModel))
            }.store(in: &cancellables)
    }
}
