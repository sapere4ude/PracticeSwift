//
//  ApiService.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import Foundation
import Combine

enum API {
    case fetchTodos  // 할 일 가져오기
    case fetchPosts  // 포스트 가져오기
    case fetchUsers  // 유저 가져오기
    
    var url: URL {
        switch self {
        case .fetchPosts:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .fetchTodos:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        case .fetchUsers:
            return URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
    }
}

enum ApiService {
    static func fetchUsers() -> AnyPublisher<[User],Error> {
        return URLSession.shared.dataTaskPublisher(for: API.fetchUsers.url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchTodos() -> AnyPublisher<[Todo],Error> {
        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchPosts(_ todosCount: Int = 0) -> AnyPublisher<[Post],Error> {
        print("fetchPosts > todosCount: \(todosCount)")
        return URLSession.shared.dataTaskPublisher(for: API.fetchPosts.url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Todos + Posts 동시호출
    static func fetchTodosAndPostsAtTheSameTime() -> AnyPublisher<([Todo],[Post]),Error> {
        let fetchedTodos = fetchTodos() // 퍼블리셔1
        let fetchedPosts = fetchPosts() // 퍼블리셔2
        
        // 두개의 퍼블리셔를 연결해준다 생각하면 됨
        return Publishers
            .CombineLatest(fetchedTodos, fetchedPosts)  // 두개를 합치는것
            .eraseToAnyPublisher() // 이걸 통해 AnyPublisher<([Todo],[Post]),Error> 형태로 만들어줌
    }
    
    // Todos 호출 뒤에 그 결과로 Posts 호출하기
    static func fetchTodosAndThenPosts() -> AnyPublisher<[Post],Error> {
        return fetchTodos().flatMap { posts in
            return fetchPosts(posts.count).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    // Todos 호출 뒤에 그 결과로 특정 조건이 성립되면 Posts 호출하기
    static func fetchTodosAndPostsApiCallConditionally() -> AnyPublisher<[Post],Error> {
        return fetchTodos()
            .map { $0.count }   // todos.count
            .filter { $0 >= 200 }
            .flatMap { _ in
                return fetchPosts().eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}
