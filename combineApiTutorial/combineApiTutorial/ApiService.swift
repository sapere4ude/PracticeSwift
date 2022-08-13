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
    
    var url: URL {
        switch self {
        case .fetchPosts:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .fetchTodos:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        }
    }
}

enum ApiService {
    static func fetchTodos() -> AnyPublisher<[Todo],Error> {
        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
            .map { $0.data }
            .decode(type:  , decoder:  )
    }
}
