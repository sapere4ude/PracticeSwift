//
//  ViewController.swift
//  ExAdPlayer
//
//  Created by Kant on 2/9/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var trailingConstraint: NSLayoutConstraint?
    private var adPlayerHeightConstraint: NSLayoutConstraint?
    
    let adPlayer: AdPlayer = AdPlayer()
    
    let dragView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상 설정
        view.layer.shadowOpacity = 0.3 // 그림자 투명도 설정
        view.layer.shadowOffset = CGSize(width: 1, height: 1) // 그림자 오프셋 설정
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dragImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "arrow.backward")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.shadowColor = UIColor.black.cgColor // 그림자 색상 설정
        imageView.layer.shadowOpacity = 0.3 // 그림자 투명도 설정
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1) // 그림자 오프셋 설정
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        adPlayer.prepareToPlay(url: url)
        
        adPlayer.delegate = self
    }
    
    internal func setupUI() {
        view.addSubview(adPlayer)
        view.addSubview(dragView)
        //dragView.addSubview(dragImageView)
        dragView.addSubview(arrowImageView)
        adPlayer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupThumbnail() {
        if let imageUrl = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg") {
            loadImage(from: imageUrl) { image in
                if let loadedImage = image {
                    DispatchQueue.main.async {
                        self.dragImageView.image = loadedImage
                    }
                }
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            adPlayer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            adPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            adPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dragView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50),
            dragView.heightAnchor.constraint(equalToConstant: 100),
            dragView.topAnchor.constraint(equalTo: adPlayer.topAnchor),
            dragView.leadingAnchor.constraint(equalTo: adPlayer.leadingAnchor),
            dragView.bottomAnchor.constraint(equalTo: adPlayer.bottomAnchor),
            
//            dragImageView.topAnchor.constraint(equalTo: dragView.topAnchor),
//            dragImageView.leadingAnchor.constraint(equalTo: dragView.leadingAnchor),
//            dragImageView.bottomAnchor.constraint(equalTo: dragView.bottomAnchor),
//            dragImageView.trailingAnchor.constraint(equalTo: dragView.trailingAnchor),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: 30),
            arrowImageView.heightAnchor.constraint(equalToConstant: 30),
            arrowImageView.trailingAnchor.constraint(equalTo: dragView.trailingAnchor, constant: 15),
            arrowImageView.centerYAnchor.constraint(equalTo: dragView.centerYAnchor)
        ])
        
        adPlayerHeightConstraint = adPlayer.heightAnchor.constraint(equalToConstant: 100)
        adPlayerHeightConstraint?.isActive = true
        
        trailingConstraint = dragView.trailingAnchor.constraint(equalTo: adPlayer.trailingAnchor,
                                                                     constant: -50)
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
            trailingConstraint?.constant += translation.x
            self.arrowImageView.alpha -= 0.1
        }
        
        gesture.setTranslation(.zero, in: view)
        
        if gesture.state == .ended {
            if gestureView.center.x < 80 {
                self.removedragView(gestureView)
            } else {
                self.resetdragView()
            }
        }
    }
}

extension ViewController: PlayerConfigurable {
    func prepareUI() {
        //setupThumbnail()
        setupUI()
        setupConstraint()
        addPanGesture(view: dragView)
    }
}

// MARK: UI
extension ViewController {
    
    private func removedragView(_ gestureView: UIView) {
        UIView.animate(withDuration: 1.0, animations: {
            self.trailingConstraint?.constant = -UIScreen.main.bounds.width
            self.view.layoutIfNeeded()
        }) { _ in
            gestureView.alpha = 0
            gestureView.removeFromSuperview()
            self.prepareAdPlayerAnimation()
        }
    }
    
    private func resetdragView() {
        UIView.animate(withDuration: 1.0) {
            self.trailingConstraint?.constant = -50
            self.arrowImageView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func prepareAdPlayerAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.adPlayerHeightConstraint?.constant = 140
            self.view.layoutIfNeeded()
        }) { _ in
            self.adPlayer.play()
            self.adPlayer.thumbnailImageView.isHidden = true
        }
    }
}

