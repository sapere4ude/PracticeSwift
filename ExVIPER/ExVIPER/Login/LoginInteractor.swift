//
//  LoginInteractor.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import Foundation

enum AuthenticationError: Error {
    case invalid
}

protocol LoginInteractorProtocol {
    func authenticate(userName: String, password: String) async -> Result<Bool, Error>
}

final class LoginInteractor: LoginInteractorProtocol {
    func authenticate(userName: String, password: String) async -> Result<Bool, Error> {
        return userName == "test" && password == "password" ? .success(true) : .failure(AuthenticationError.invalid)
    }
}
