//
//  ViewController.swift
//  ExSnapkitAnimation
//
//  Created by Kant on 2022/06/17.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    static let defaultAppearDuration = 7.0
    static let defaultDisAppearDuration = 7.0
    
    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var contentsLayout: UIView?
    var bottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.testView)
        
//        self.testView.snp.makeConstraints {
////            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50))
//            $0.width.equalToSuperview()
//            $0.height.equalTo(100)
//
////            $0.bottom.equalToSuperview().offset(-300)
//        }

        self.testView.translatesAutoresizingMaskIntoConstraints = false
        self.testView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.testView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        
        let draggedGesture = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture(_:)))
        testView.addGestureRecognizer(draggedGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.testView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -500)
        self.testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAppearAnimation()
    }
    
//    func startAppearAnimation() {
//        self.bottom?.constant = (self.testView.bounds.height ?? self.testView.bounds.height) * -1
//        self.testView.layoutIfNeeded()
//
//        UIView.animate(withDuration: Self.defaultAppearDuration) {
//            self.bottom = self.testView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//            self.bottom?.constant = 0
//            self.testView.layoutIfNeeded()
//        }
//    }
    func startAppearAnimation() {
        self.bottom?.constant = (self.testView.bounds.height ?? self.testView.bounds.height) * -1
//        self.testView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
//        self.testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        self.testView.layoutIfNeeded()
        
        UIView.animate(withDuration: Self.defaultAppearDuration) {
            self.bottom?.constant = 0.0
            self.testView.layoutIfNeeded()
        }
    }
    
    func startDisAppearAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: Self.defaultDisAppearDuration) {
            self.bottom?.constant = (self.testView.bounds.height ?? self.testView.bounds.height) * -1
//            self.testView.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(0)
//            }
//            self.testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            
            self.testView.layoutIfNeeded()
        } completion: { errSecSuccess in
//            self.testView.removeFromSuperview()
            completion()
        }
    }
    
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended,
             .cancelled,
             .failed:
            let trans = gesture.translation(in: self.testView)
            if trans.y < 0 {
                self.respondToSwipeUpGesture(gesture)
            } else {
                self.respondToSwipeDownGesture(gesture)
            }
        default:
            return
        }
    }
    
    @objc func respondToSwipeUpGesture(_ gesture: UIPanGestureRecognizer) {
        print(#function)
    }
    
    @objc func respondToSwipeDownGesture(_ gesture: UIPanGestureRecognizer) {
        print(#function)
        self.startDisAppearAnimation {
            
        }
    }
}
