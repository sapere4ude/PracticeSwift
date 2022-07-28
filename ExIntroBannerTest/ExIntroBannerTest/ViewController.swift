//
//  ViewController.swift
//  ExIntroBannerTest
//
//  Created by kant on 2022/07/27.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    var contentsView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .yellow
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }()
    
    var vodPlayerView: UIView = {
        let playerView = UIView()
        playerView.backgroundColor = .red
        return playerView
    }()
    
    var okBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .magenta
        button.setTitle("예매하기", for: .normal)
        return button
    }()
    
    var exitBtn: UIButton = {
       let button = UIButton()
        button.setTitle("종료", for: .normal)
        return button
    }()
    
    var disableTodayShowBtn: UIButton = {
       let button = UIButton()
        button.setTitle("오늘 다시 보지 않기", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor, constant: -view.frame.height),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.equalTo(self.view.snp_leading)
            $0.trailing.equalTo(self.view.snp_trailing)
            $0.top.equalTo(self.view.snp_top)
            $0.bottom.equalTo(self.view.snp_bottom)
        }
        
        backgroundView.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.width.equalTo(backgroundView)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().offset(-100) // 정상동작하는거
        }
        
        // imageTypeUI
//        imageView.snp.makeConstraints {
//            $0.height.equalTo(100)
//        }
        
        
        // stackView 쌓기
        [imageView].forEach {
            contentsView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // VodTypeUI
//        [imageView].forEach {
//            contentsView.addArrangedSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        // VodTypeWithCinemaUI
        
        
        
        // centerX, centerY 동시에 있는 경우엔 크기가 커지는 문제가 발생함
        backgroundView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.centerX.equalTo(backgroundView)
            $0.bottom.equalTo(backgroundView.snp_bottom).offset(-30)
        }
        
        backgroundView.addSubview(exitBtn)
        exitBtn.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(35)
            $0.trailing.equalTo(self.backgroundView.snp_trailing).offset(-30)
            $0.top.equalTo(self.backgroundView.snp_top).offset(30)
        }
        
        backgroundView.addSubview(disableTodayShowBtn)
        disableTodayShowBtn.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.trailing.equalTo(self.backgroundView.snp_trailing).offset(-30)
            $0.bottom.equalTo(self.backgroundView.snp_bottom).offset(-20)
        }
        
        show()
    }
    
    func show() {
        view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.view.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            
        }
    }
}

