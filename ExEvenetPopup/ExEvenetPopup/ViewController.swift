//
//  ViewController.swift
//  ExEvenetPopup
//
//  Created by Kant on 2022/07/13.
//

// 이벤트를 보여주는 뷰
// 오픈했을때 어떤 방식으로 보여줄지
// 하루에 한번만 보여주도록, 00시 될때 초기화



import UIKit

class ViewController: UIViewController {

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("클릭해주세요", for: .normal)
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        button.backgroundColor = .green
        return button
    }()
    
    let eventView: UIView = {
       let eventView = UIView()
        eventView.backgroundColor = .yellow
        eventView.translatesAutoresizingMaskIntoConstraints = false
        return eventView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    @objc func btnAction() {
        print(#function)
//        view.addSubview(eventView)
//        eventView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            eventView.widthAnchor.constraint(equalToConstant: 300),
//            eventView.heightAnchor.constraint(equalToConstant: 300),
//            eventView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            eventView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        ])
        EventView.shared.show(vc: self)
    }
}
