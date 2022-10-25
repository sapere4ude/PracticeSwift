//
//  SRP.swift
//  SOLID
//
//  Created by Kant on 2022/10/25.
//

// SRP(Single Responsibility Principle) - 단일 책임 원칙

import Foundation

struct User {
    var name = ""
    var age = 1
}

// Bad case
//class LoginService {
//    func login(id: String, pw: String) {
//        let userData = requestLogin()
//        let user = decodeUserInform(data: userData)
//        saveUserOnDatabase(user: user)
//    }
//
//    private func requestLogin() -> Data {
//        // Call API
//        return Data()
//    }
//
//    private func decodeUserInform(data: Data) -> User {
//        // Decoding User Inform from Data
//        return User(name: "", age: 10)
//    }
//
//    private func saveUserOnDatabase(user: User) {
//        // Save User
//    }
//}

// Good case
protocol APIHandlerProtocol {
    func requestLogin() -> Data
}

protocol DecodingHandlerProtocol {
    func decode<T>(from data: Data) -> T
}

protocol DBHandlerProtocol {
    func saveOnDatabase<T>(inform: T)
}

class LoginService {
    let apiHandler: APIHandlerProtocol
    let decodingHandler: DecodingHandlerProtocol
    let dbHandler: DBHandlerProtocol

    init(apiHandler: APIHandlerProtocol,
         decodingHandler: DecodingHandlerProtocol,
         dbHandler: DBHandlerProtocol) {
        self.apiHandler = apiHandler
        self.decodingHandler = decodingHandler
        self.dbHandler = dbHandler
    }

    func login() {
        let loginData = apiHandler.requestLogin()
        let user: User = decodingHandler.decode(from: loginData)
        dbHandler.saveOnDatabase(inform: user)
    }
}
