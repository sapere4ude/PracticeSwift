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
        
        // Here we need to add navigation controller
        self.title = "Users"
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
    }
    
    @objc func onTapAdd() {
        let user = User(userID: 48954, id: 4534, title: "CodeLib", body: "RxSwift Crud")
        self.viewModel.addUser(user: user)
        
    }
    
    func bindTableView() {
        // case1. 기본적인 델리게이트 설정 + 받아온 값들 뿌려주기
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row,item, cell) in
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
        }.disposed(by: disposeBag)
        
        // case2. 수정
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }

            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", index: indexPath.row)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        // case3. 삭제
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: disposeBag)
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
    
    // Part2. Rx를 사용했기 때문에 delete, edit 했을때 Rx가 알아서 정보에 대한 reload를 진행해준다
    func addUser(user: User) {
        guard var users = try? users.value() else { return }  //.value -> Gets the current value or throws an error.
        users.insert(user, at: 0)
        self.users.on(.next(users)) // .on -> Event to send to the observers.
    }
    
    func deleteUser(index: Int) {
        guard var users = try? users.value() else { return }
        users.remove(at: index)
        self.users.on(.next(users))
    }
    
    func editUser(title: String, index: Int) {
        guard var users = try? users.value() else { return }
        users[index].title = title
        self.users.on(.next(users))
    }
}

// JSON 더미 데이터 사용할 수 있는 링크 : https://jsonplaceholder.typicode.com/posts
// JSON 리스트 Codable 형식으로 변환해주는 링크 : https://app.quicktype.io/

struct User: Codable {
    let userID, id: Int
    var title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


