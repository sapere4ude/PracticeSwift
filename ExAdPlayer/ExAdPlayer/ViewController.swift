//
//  ViewController.swift
//  ExAdPlayer
//
//  Created by Kant on 2/9/24.
//

import UIKit

class ViewController: UIViewController {
    
    var adPlayer: AdPlayer = AdPlayer()
    
    private var trailingConstraint: NSLayoutConstraint?
    
    let dragImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상 설정
        view.layer.shadowOpacity = 0.3 // 그림자 투명도 설정
        view.layer.shadowOffset = CGSize(width: 1, height: 1) // 그림자 오프셋 설정
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraint()
        
        addPanGesture(view: dragImageView)
    }

    private func setupUI() {
        view.addSubview(adPlayer)
        view.addSubview(dragImageView)
        adPlayer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            adPlayer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            adPlayer.heightAnchor.constraint(equalToConstant: 150),
            adPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            adPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dragImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50),
            dragImageView.heightAnchor.constraint(equalToConstant: 150),
            dragImageView.topAnchor.constraint(equalTo: adPlayer.topAnchor),
            dragImageView.leadingAnchor.constraint(equalTo: adPlayer.leadingAnchor),
            dragImageView.bottomAnchor.constraint(equalTo: adPlayer.bottomAnchor)
        ])
        
        trailingConstraint = dragImageView.trailingAnchor.constraint(
            equalTo: adPlayer.trailingAnchor,
            constant: -50
        )
        trailingConstraint?.isActive = true
    }
    
    func addPanGesture(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }

        if translation.x < 0 {
            //gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y)
            trailingConstraint?.constant += translation.x
        }
        
        gesture.setTranslation(.zero, in: view)

        if gesture.state == .ended {
            if gestureView.center.x < -90.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    gestureView.alpha = 0
                }) { _ in
                    gestureView.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 3.0) {
                    self.trailingConstraint?.constant = -50
                }
            }
        }
    }
}

