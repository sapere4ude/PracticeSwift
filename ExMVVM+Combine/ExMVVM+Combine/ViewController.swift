//
//  ViewController.swift
//  ExMVVM+Combine
//
//  Created by kant on 2023/03/03.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    let todoViewModel = TodoViewModel(repository: DefaultTodoRepository())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoViewModel.fetchUser()
        
        // fetchUser() 이후에 todoViewModel.todoModel 으로 값에 접근하면 nil 이 찍히는걸 확인할 수 있다.
        // fetchUser() 메서드가 불리고 바로 print 를 통해 값을 검사하는 경우 생기는 오류인데
        // 이런 경우엔 구독(sink) 을 통해 viewModel의 model 에 접근하여 전달받은 값이 있는지 체크할 수 있다.
        
        todoViewModel.$todoModel.sink { todoModel in
            if let title = todoModel?.title {
                print("title:\(title)")
            }
            if let id = todoModel?.id {
                print("id:\(id)")
            }
        }.store(in: &cancellables)
    }
}
