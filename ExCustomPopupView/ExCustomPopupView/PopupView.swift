//
//  PopupView.swift
//  ExCustomPopupView
//
//  Created by Kant on 2022/06/20.
//

import Foundation
import UIKit
import SnapKit

class PopupView: UIView {
    
    var a: CGFloat = 0.0
    
    let thumbnailImageView: UIImageView = {
            let thumbnail = UIImageView()
            thumbnail.layer.cornerRadius = 6
            thumbnail.layer.masksToBounds = true
            thumbnail.contentMode = .scaleToFill
//            thumbnail.image = UIImage.imageStyle(named: "default_thumbnail_normal")
            thumbnail.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
            thumbnail.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
            thumbnail.setContentHuggingPriority(.defaultLow, for: .horizontal)
            return thumbnail
        }()

    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "테스트 테스트 테스트 테스트 테스트 테스트"
        title.backgroundColor = .yellow
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        return title
    }()

    lazy var subTitleLabel: UILabel = {
        let title = UILabel()
        title.text = "서브텍스트 테스트 테스트 테스트 테스트 테스트 테스트"
        title.backgroundColor = .yellow
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        return title
    }()

    let cancelButton: UIButton = {
        let more = UIButton()
        more.setTitle("버튼", for: .normal)
        more.backgroundColor = .green
        more.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return more
    }()

    let joinButton: UIButton = {
        let more = UIButton()
        more.setTitle("버튼", for: .normal)
        more.backgroundColor = .red
        return more
    }()
    
    struct AFTabBarUpperView {
        var width: CGFloat = 382
        var height: CGFloat = 150
        var edgeSpace: CGFloat = 16
        var bottomSpace: CGFloat = 40
        var borderWidth: CGFloat = 1.5
        var bgColor: UIColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
        var borderColor: CGColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
        var autoDismiss: Bool = true
        var autoDismissSeconds: Double = 2
    }

    
    var config = AFTabBarUpperView()
    
    var panGesture = UIPanGestureRecognizer()
    
    @objc private func dismiss() {
        dismiss {
            self.dismissAction?()
        }
    }
    
    @objc private func tap() {
        tapAction?()
    }
    
    private var dismissAction: (() -> Void)?
    private var tapAction: (() -> Void)?
    
    init(from view: UIView) {
        super.init(frame: .zero)
        view.addSubview(self)
        setupConstraints(superView: view)
        
        backgroundColor = config.bgColor
        layer.borderWidth = config.borderWidth
        layer.borderColor = config.borderColor
        layer.cornerRadius = 12
        clipsToBounds = true
        
        dismiss(withDuration: 0, onComplete: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(tapGesture)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        
        
        self.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        thumbnailImageView.size(width: 100)


        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 9).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        self.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 9).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        self.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        joinButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 32).isActive = true

        self.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.joinButton.leadingAnchor, constant: -25).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.respondToPanGesture(_:)))
        self.addGestureRecognizer(panGesture)
        self.isUserInteractionEnabled = true
    }
    
    private func setupConstraints(superView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(config.edgeSpace * 2)).isActive = true
        let widthConstraint = widthAnchor.constraint(equalToConstant: config.width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        heightAnchor.constraint(equalToConstant: config.height).isActive = true
        
        let leadingConstraint = leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: config.edgeSpace)
        leadingConstraint.priority = .defaultHigh
        leadingConstraint.isActive = true
        
        let trailingConstraint = trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -config.edgeSpace)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true
        
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -config.bottomSpace).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        a = self.frame.origin.y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var defaultHeight: CGFloat = 300
    
    func show(withDuration duration: Double = 0.3, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss
        
        guard duration != 0 else {
            alpha = 1
            isHidden = false
            return
        }
        
        self.transform = .init(translationX: 0, y: self.config.bottomSpace)
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
            self?.isHidden = false
            self?.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            guard self.config.autoDismiss else {
                return
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + self.config.autoDismissSeconds) {
//                self.dismiss()
//            }
        }
    }
    
    @objc func dismiss(withDuration duration: Double = 0.3, onComplete: (() -> Void)? = nil) {
        guard duration != 0 else {
            alpha = 0
            isHidden = true
            onComplete?()
            return
        }
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = .init(translationX: 0, y: self.config.bottomSpace)
        } completion: { [weak self] _ in
            self?.isHidden = true
            onComplete?()
        }
    }
    
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: self)
        let viewVelocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if viewVelocity.y > 0 {
                    UIView.animate(withDuration: 0.5) {
                        self.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                    }
                }
            }
        case .ended:
            if viewTranslation.y < 60 {
                UIView.animate(withDuration: 0.5) {
                    self.transform = .identity
                }
            } else {
                dismiss()
            }
        default:
            break
        }
    }
}

