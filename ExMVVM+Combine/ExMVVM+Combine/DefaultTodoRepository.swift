//
//  DefaultTodoRepository.swift
//  ExMVVM+Combine
//
//  Created by kant on 2023/03/03.
//

import Combine
import Foundation

protocol TodoRepository {
    func fetchUser() -> AnyPublisher<TodoModel, Error>
}

class DefaultTodoRepository: TodoRepository {
    func fetchUser() -> AnyPublisher<TodoModel, Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")
        let test = url!
        return URLSession.shared.dataTaskPublisher(for: test)
            .map { $0.data }
            .decode(type: TodoModel.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                // 에러 처리
                return error
            }
            .eraseToAnyPublisher()
    }
}
