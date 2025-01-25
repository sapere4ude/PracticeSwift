//
//  HomeRouter.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import UIKit

final class HomeRouter {
    func builder() -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter()
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
