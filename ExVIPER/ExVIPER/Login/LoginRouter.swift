//
//  LoginRouter.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import UIKit

protocol LoginRouterProtocol {
    func navigateToHome()
}

final class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToHome() {
        let homeViewController = HomeRouter().builder()
        viewController?.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func builder() -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        return view
    }
}
