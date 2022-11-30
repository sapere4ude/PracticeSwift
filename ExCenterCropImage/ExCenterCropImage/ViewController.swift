//
//  ViewController.swift
//  ExCenterCropImage
//
//  Created by kant on 2022/09/30.
//

import UIKit

class ViewController: UIViewController {

    private var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 1.0
        return visualEffectView
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let centerPositionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setThumbnailImageView()
        setBlurEffectUI()
        setCenterPositionImage()
    }
    
    func setBlurEffectUI() {
        thumbnailImageView.addSubview(blurEffect)
        
        blurEffect.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blurEffect.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            blurEffect.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            blurEffect.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            blurEffect.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor)
        ])
    }
    
    func setThumbnailImageView() {
        thumbnailImageView.image = UIImage(named: "sample")
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thumbnailImageView)

        NSLayoutConstraint.activate([
            thumbnailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -200),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 200),
        ])
    }
    
    func setCenterPositionImage() {
        centerPositionImageView.image = UIImage(named: "sample")
        centerPositionImageView.translatesAutoresizingMaskIntoConstraints = false
        centerPositionImageView.layer.zPosition = 10
        
        view.addSubview(centerPositionImageView)
        
        NSLayoutConstraint.activate([
            centerPositionImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerPositionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerPositionImageView.widthAnchor.constraint(equalToConstant: 200),
            centerPositionImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

