//
//  ViewController.swift
//  MVVMApp
//
//  Created by Kant on 2022/06/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

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
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row,item, cell) in
//            cell.textLabel?.text = item.title
//            cell.detailTextLabel?.text = "\(item.id)"
//        }.disposed(by: disposeBag)
//
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,User>> { _, tableView, indexPath, item in     // <SectionModel> 이라는건 RxDataSources 에 있는것
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        self.viewModel.users.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // case3. 삭제
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(indexPath: indexPath)
        }).disposed(by: disposeBag)
        
        // case2. 수정
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    
}

class ViewModel {
//    var users = BehaviorSubject(value: [User]()) // 가장 최신에 받은 next 이벤트를 전달받을 수 있다
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])  // RxDataSources 에서 사용하는 SectionModel에 맞는 형식
                                    
    func fetchUser() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
//                self.users.on(.next(responseData))
                let sectionUser = SectionModel(model: "First", items: [User(userID: 0, id: 1, title: "test", body: "body test")])
                let secondSection = SectionModel(model: "Second", items: responseData)
                self.users.on(.next([sectionUser, secondSection]))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // Part2. Rx를 사용했기 때문에 delete, edit 했을때 Rx가 알아서 정보에 대한 reload를 진행해준다
    func addUser(user: User) {
        guard var sections = try? users.value() else { return }  //.value -> Gets the current value or throws an error.
        var currentSection = sections[0]
        currentSection.items.append(User(userID: 2, id: 32, title: "New Data", body: "New body"))
        sections[0] = currentSection
        self.users.onNext(sections)     // Rx를 사용하면 좋은점이 뷰가 생기고 나서 reload같은걸 안해줘도 알아서 업데이트 된다는 점
//        users.insert(user, at: 0)
//        self.users.on(.next(users)) // .on -> Event to send to the observers.
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
//        users.remove(at: index)
//        self.users.on(.next(users)) // .on(.next 이걸 이용해서 값을 갱신해주는 것
    }
    
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
//        users[index].title = title
//        self.users.on(.next(users))
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


