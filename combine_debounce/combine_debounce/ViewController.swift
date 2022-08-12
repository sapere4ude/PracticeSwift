//
//  ViewController.swift
//  combine_debounce
//
//  Created by Kant on 2022/08/11.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    private lazy var searchController: UISearchController = {
       let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.accessibilityIdentifier = "mySearchBarTextField"
        return searchController
    }()
    
    var mySubscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        searchController.isActive = true
        
        searchController.searchBar.searchTextField
            .myDebounceSearchPublisher
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
                print("receivedValue: \(receivedValue)")
                self.myLabel.text = receivedValue
            }.store(in: &mySubscription)

    }
}

extension UISearchTextField {
    var myDebounceSearchPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UISearchTextField }
            .map { $0.text ?? "" }
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .filter { $0.count > 0 } // 글자가 존재하는 경우에만 이벤트 전달
            .print()
            .eraseToAnyPublisher()
    }
}

