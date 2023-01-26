//
//  ViewController.swift
//  ExCustomNotificationCenter+Combine
//
//  Created by kant on 2022/12/12.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController {
    
    var result: String = "success!"
    private var cancellableBag = Set<AnyCancellable>()
    
    private lazy var oldButton: UIButton = {
        let button = UIButton()
        button.setTitle("Old-fashioned way", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(touchOldWay), for: .touchUpInside)
        return button
    }()
    
    private lazy var combineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Combine way", for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(touchCombineWay), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(oldButton)
        oldButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
    
        view.addSubview(combineButton)
        combineButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(100)
            $0.top.equalTo(oldButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: Notification.Name("tapped"), object: nil)
        
    }
    
    @objc func touchOldWay() {
        NotificationCenter.default.post(name: Notification.Name("tapped"), object: self)
    }
    
    // The old-fashioned way
    @objc func cardTapped(_ n: Notification) {
        if let card = n.object as? Self {
            let name = card.result
            print("result: \(result)")
        }
    }
    
    
    // cardTapped 액션이 끝나고 난 뒤 Combine 메서드를 실행하게 된다.
    @objc func touchCombineWay() {
        
        NotificationCenter.default.post(name: Notification.Name("tapped"), object: self)
        
        let cardTappedCardNamePublisher = NotificationCenter.default
            .publisher(for: Notification.Name("tapped")) // tapped 함수를 Publish 한다.
            .sink(receiveCompletion: { _ in
                print("completion")
            }, receiveValue: { _ in
                print("combine button click") } // tapped 함수의 역할이 종료될 때 호출된다.
            )
            .store(in: &cancellableBag)
    }
}

