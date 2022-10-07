//
//  ViewController.swift
//  ExCenterCropImage
//
//  Created by kant on 2022/09/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    // CATCH 타입일 경우 사용
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -100),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 300),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        thumbnailImageView.image = UIImage(named: "sample")
//            Bundle.main.url(forResource: "sample", withExtension: "png")
    }
    
//    func setBlurEffectUI() {
////        baseView.addSubview(thumbnailImageView)
////        imageView.addSubview(thumbnailImageView)
//
//        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
////            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
////            thumbnailImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            thumbnailImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 500),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 400)
//
//        ])
//
//        let url = URL(string: "https://iflv14.afreecatv.com/clip/20220915/131/a6c18144-7f44-4573-83ac-0f3a073c6778/244131_r.jpg")
//        let data = try! Data(contentsOf: url!)
//
//        thumbnailImageView.contentMode = .center
//        thumbnailImageView.image = UIImage(data: data)
////        thumbnailImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//    }
}

