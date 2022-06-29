//
//  VodPopupView.swift
//  ExCustomPopupView
//
//  Created by Kant on 2022/06/29.
//

//import Foundation
//import UIKit
//import SnapKit
//
//class VodPodUpView: UIView {
//
//    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
//
//    var bgView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
//        return view
//    }()
//
//    var contentsView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .yellow
//        return view
//    }()
//
//    private func setupConstraints() {
//
//        self.addSubview(bgView)
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//
//
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
import Foundation
import UIKit
import SnapKit

class VodPodUpView: UIView {
    
    enum TabBarUpperMode {
        case expire
        case join
        case gift
    }
    
    var isShow: Bool = false
    
    static var shared = VodPodUpView(frame: CGRect(x: 0, y: 0, width: 350, height: 812))
    
    var tabBarUpperMode: TabBarUpperMode = .gift
    var titleText: String?
    var subTitleText: String?
    var accessText: String?
    var width: CGFloat = 382
    var height: CGFloat = 150
    var edgeSpace: CGFloat = 16
    var bottomSpace: CGFloat = 20
    //    var borderWidth: CGFloat = 1.5
    var bgColor: UIColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
    //    var borderColor: CGColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
    var autoDismiss: Bool = true
    var autoDismissSeconds: Double = 2
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        return view
    }()
    
    var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    
    private var dismissAction: (() -> Void)?
    private var tapAction: (() -> Void)?
    
    @objc private func dismiss() {
        dismiss {
            self.dismissAction?()
        }
    }
    
    @objc private func tap() {
        tapAction?()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
    }
    
    @objc private func accessBtnClick() {
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        print(#function)
        backgroundColor = self.bgColor
        layer.cornerRadius = 12
        clipsToBounds = true
        
        dismiss(withDuration: 0, onComplete: nil)
        
        self.addSubview(bgView)
        
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

    }
    
    // MARK: - setup Constraints
    private func setupConstraints(superView view: UIView) {
        print(#function)
        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(self.edgeSpace * 2)).isActive = true
//        let widthConstraint = widthAnchor.constraint(equalToConstant: self.width)
//        widthConstraint.priority = .defaultHigh
//        widthConstraint.isActive = true
//
//        heightAnchor.constraint(equalToConstant: self.height).isActive = true
//
//        let leadingConstraint = leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: self.edgeSpace)
//        leadingConstraint.priority = .defaultHigh
//        leadingConstraint.isActive = true
//
//        let trailingConstraint = trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -self.edgeSpace)
//        trailingConstraint.priority = .defaultHigh
//        trailingConstraint.isActive = true
//
//        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -self.bottomSpace).isActive = true
//        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - show & hide, pan gesture
    func show(vc: UIViewController, withDuration duration: Double = 0.3, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss
        
//        self.width = 382
//        self.height = 150
//        self.edgeSpace = 16
//        self.bottomSpace = 20
//        self.layer.borderWidth = 1.5
//        self.bgColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
//        self.layer.borderColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
//        self.autoDismiss = true
//        self.autoDismissSeconds = 2
        
        guard duration != 0 else {
            alpha = 1
            isHidden = false
            return
        }
        
        vc.view.addSubview(self) // <- 이 코드가 실행되면 init(frame:CGRect) 함수가 실행된다. 그렇게 frame 을 설정해주고 아랫줄로 넘어가게된다.
        setupConstraints(superView: vc.view)
        
        guard self.isShow == false else { return }
        
        //        if Double.random(in: 0.0...100.0) < 45.0 {
        self.transform = .init(translationX: 0, y: self.bottomSpace)
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
        //        }
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
            self.transform = .init(translationX: 0, y: self.bottomSpace)
        } completion: { [weak self] _ in
            self?.isHidden = true
            self?.isShow = false
            onComplete?()
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        
    }
    
    func keyboardWillHide(notification: Notification) {
        self.removeFromSuperview()
    }
    
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: self)
        let viewVelocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if viewVelocity.y > 0 {
                    //                       UIView.animate(withDuration: 0.5) {
                    self.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                    //                       }
                }
            }
        case .ended:
            if viewTranslation.y < self.height/2 {
                //                   UIView.animate(withDuration: 0.5) {
                self.transform = .identity
                //                   }
            } else {
                dismiss()
            }
        default:
            break
        }
    }
}
