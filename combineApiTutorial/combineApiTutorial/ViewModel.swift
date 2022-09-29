//
//  ViewModel.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    func fetchTodos() {
        ApiService.fetchTodos()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodos: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodos: finished")
                }
            } receiveValue: { (todos: [Todo]) in
                print("ViewModel - fetchTodos / todos.count: \(todos.count)")
            }.store(in: &subscriptions)
    }
    
    func fetchPosts() {
        ApiService.fetchPosts()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchPosts: err: \(err)")
                case .finished:
                    print("ViewModel - fetchPosts: finished")
                }
            } receiveValue: { (posts: [Post]) in
                print("ViewModel - fetchPosts / posts.count: \(posts.count)")
            }.store(in: &subscriptions)
    }
    
    // todos + posts 동시호출
    func fetchTodosAndPosts() {
        ApiService.fetchTodosAndPostsAtTheSameTime()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime: finished")
                }
            } receiveValue: { (todos: [Todo], posts: [Post]) in
                print("ViewModel - fetchTodosAndPostsAtTheSameTime / todos.count: \(todos.count)/ posts.count: \(posts.count)")
            }.store(in: &subscriptions)
    }
    
    // todos 호출 후 응답으로 posts 호출
    func fetchTodosAndThenPosts() {
        ApiService.fetchTodosAndThenPosts()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndThenPosts: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndThenPosts: finished")
                }
            } receiveValue: { (posts: [Post]) in
                print("ViewModel - fetchTodosAndThenPosts / posts.count: \(posts.count)")
            }.store(in: &subscriptions)
    }
    
    // todos 호출 후 응답에 따른 조건으로  posts 호출
    func fetchTodosAndPostsApiCallConditionally() {
        ApiService.fetchTodosAndPostsApiCallConditionally()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndPostsApiCallConditionally: finished")
                }
            } receiveValue: { (posts: [Post]) in
                print("ViewModel - fetchTodosAndPostsApiCallConditionally / posts.count: \(posts.count)")
            }.store(in: &subscriptions)
    }
    
    // todos 호출 후 응답에 따른 조건으로 다음 API 호출
    // todos.count < 200 : 포스트 호출 ? 유저 호출
    func fetchTodosAndApiCallConditionally() {
        let shouldFetchPosts: AnyPublisher<Bool, Error> =
        ApiService.fetchTodos()
            .map { todos in
                return todos.count >= 200
            }.eraseToAnyPublisher()
        
        shouldFetchPosts
            .filter { $0 == true }
            .flatMap { _ in
                return ApiService.fetchPosts()
            }.sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndApiCallConditionally: finished")
                }
            } receiveValue: { (posts: [Post]) in
                print("ViewModel - fetchTodosAndApiCallConditionally / posts.count: \(posts.count)")
            }.store(in: &subscriptions)
        
        shouldFetchPosts
            .filter { $0 == false }
            .flatMap { _ in
                return ApiService.fetchUsers()
            }.sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndApiCallConditionally: finished")
                }
            } receiveValue: { (users: [User]) in
                print("ViewModel - fetchTodosAndApiCallConditionally / users.count: \(users.count)")
            }.store(in: &subscriptions)
    }
}
