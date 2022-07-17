//
//  EventView.swift
//  ExEvenetPopup
//
//  Created by Kant on 2022/07/16.
//

import Foundation
import UIKit

class EventView: UIView {
    
    static var shared = EventView()
    
    var isShow: Bool = false
    private var dismissAction: (() -> Void)?
    private var tapAction: (() -> Void)?
    var autoDismiss: Bool = true
    var autoDismissSeconds: Double = 2
    
    let imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .red
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup Constraints
    private func setupConstraints(superView view: UIView) {
        print(#function)
        
        addSubview(imageView)
        translatesAutoresizingMaskIntoConstraints = false
        
        // 이게 있어야 전체 뷰(bgView)의 위치가 잡아지면서, 위에 올라와 있는 뷰들도 자리가 잡힌다.
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: -view.frame.height),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    func show(vc: UIViewController, withDuration duration: Double = 1.0, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss
        self.autoDismiss = true
        self.autoDismissSeconds = 2
        
        vc.view.addSubview(self)
        setupConstraints(superView: vc.view)
        
        guard duration != 0 else {
            alpha = 1
            isHidden = false
            return
        }
        
        self.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
            self?.isHidden = false
            self?.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            guard self.autoDismiss else {
                return
            }
            self.isShow = true
        }
    }
    
    @objc func dismiss(withDuration duration: Double = 1.5, onComplete: (() -> Void)? = nil) {
        guard duration != 0 else {
            alpha = 0
            isHidden = true
            onComplete?()
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        } completion: { [weak self] _ in
            self?.isHidden = true
            self?.isShow = false
            onComplete?()
        }
    }
}

