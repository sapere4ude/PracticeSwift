//
//  HomePresenter.swift
//  ExVIPER
//
//  Created by Kant on 1/25/25.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
}

final class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    
    func viewDidLoad() {
        view?.displayWelcomeMessage("HOME Screen!")
    }
}
