//
//  ViewController.swift
//  combine_debounce
//
//  Created by Kant on 2022/08/11.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private lazy var searchController: UISearchController = {
       let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.accessibilityIdentifier = "mySearchBarTextField"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        searchController.isActive = true
    }
}

extension UISearchTextField {
    var myDebounceSearchPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UISearchTextField }
            .map { $0.text ?? "" }
            .print()
            .eraseToAnyPublisher()
    }
}

