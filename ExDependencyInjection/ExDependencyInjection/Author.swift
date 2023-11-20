//
//  Author.swift
//  ExDependencyInjection
//
//  Created by Kant on 11/20/23.
//

// 참고: https://betterprogramming.pub/better-swift-testing-with-dependency-injection-8423acefa051

import Foundation

struct Author {
    var firstName: String
    var lastName: String
    var booksWritten: Int
}

protocol AuthorServiceProtocol {
    func fetchAllAuthors() -> [Author]
}

class AuthorWebService: AuthorServiceProtocol {
    func fetchAllAuthors() -> [Author] {
        
        let author = [Author(firstName: "jaejun", lastName: "Yoo", booksWritten: 3),
                      Author(firstName: "heungmin", lastName: "Son", booksWritten: 5),
                      Author(firstName: "kangin", lastName: "Lee", booksWritten: 1)]
        return author
    }
}

// 테스트를 위한 Fake 객체
class FakeAuthorService: AuthorServiceProtocol {
    func fetchAllAuthors() -> [Author] {
        [
            Author(firstName: "Frank", lastName: "Herbert", booksWritten: 27),
            Author(firstName: "Roald", lastName: "Dahl", booksWritten: 19),
            Author(firstName: "Haruki", lastName: "Marukami", booksWritten: 14)
        ]
    }
}

class AuthorViewModel {
    private let service: AuthorServiceProtocol
    
    init(service: AuthorServiceProtocol = AuthorWebService()) {
        self.service = service
    }
    
    func allAuthors() -> [Author] {
        service.fetchAllAuthors()
    }
}
