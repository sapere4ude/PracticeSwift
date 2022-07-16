//
//  EventView.swift
//  ExEvenetPopup
//
//  Created by Kant on 2022/07/16.
//

import Foundation
import UIKit

class EventView: UIView {
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
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    func show(vc: UIViewController, withDuration duration: Double = 1.5, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss
        self.autoDismiss = true
        self.autoDismissSeconds = 2
        
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

