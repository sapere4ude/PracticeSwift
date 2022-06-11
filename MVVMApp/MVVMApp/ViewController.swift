//
//  ViewController.swift
//  MVVMApp
//
//  Created by Kant on 2022/06/09.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    private var disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        viewModel.fetchUser()
        bindTableView()
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row,item, cell) in
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
        }.disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    
}

class ViewModel {
    var users = BehaviorSubject(value: [User]()) // 가장 최신에 받은 next 이벤트를 전달받을 수 있다
    
    func fetchUser() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

// JSON 더미 데이터 사용할 수 있는 링크 : https://jsonplaceholder.typicode.com/posts
// JSON 리스트 Codable 형식으로 변환해주는 링크 : https://app.quicktype.io/

struct User: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


