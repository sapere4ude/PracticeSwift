//
//  LoginPresenter.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import Foundation

protocol LoginPresenterProtocol {
    func login(userName: String, password: String) async
}

final class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    func login(userName: String, password: String) async {
        let result = await interactor?.authenticate(userName: userName, password: password)
        
        switch result {
        case .success(let success):
            self.view?.showLoginSuccess()
        case .failure(let failure):
            self.view?.showLoginFailure(error: failure.localizedDescription)
        default:
            break
        }
    }
}
