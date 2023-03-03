//
//  TodoViewModel.swift
//  ExMVVM+Combine
//
//  Created by kant on 2023/03/03.
//

import Combine
import Foundation

class TodoViewModel: ObservableObject {
    
    private var repository: TodoRepository
    private var cancellables = Set<AnyCancellable>()
    
    @Published var todoModel: TodoModel?
    
    init(repository: TodoRepository) {
        self.repository = repository
    }

    func fetchUser() {
        repository.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self != nil else { return }
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.todoModel = model
            })
            .store(in: &cancellables)
    }
}
