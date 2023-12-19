//
//  ViewController.swift
//  ExCache
//
//  Created by Kant on 12/19/23.
//

import UIKit

class ViewController: UIViewController {

    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("클릭하면 이미지가 생성됩니다", for: .normal)
        button.backgroundColor = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        button.addTarget(self, action: #selector(tapActionButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        [customImageView, tapButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            customImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 100),
            customImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            tapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapButton.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 30),
            tapButton.widthAnchor.constraint(equalToConstant: 200),
            tapButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc func tapActionButton() {
        if let url = URL(string: "https://picsum.photos/100/100") {
            ImageDownloader.downloadImage(withURL: url) { image in
                DispatchQueue.main.async {
                    if let downloadedImage = image {
                        // 이미지 뷰에 다운로드한 이미지 표시
                        // 예: imageView.image = downloadedImage
                        self.customImageView.image = downloadedImage
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.customImageView.image = nil
                        }
                    }
                }
            }
        }
    }
}

// MARK: - NSCache 사용하기
class ImageCache {
    static let shared = ImageCache()
    
    private init() {}

    private var cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

class ImageDownloader {
    static func downloadImage(withURL url: URL, completion: @escaping (UIImage?) -> Void) {
        let imageCache = ImageCache.shared
        let key = url.absoluteString
        if let cachedImage = imageCache.getImage(forKey: key) {
            print("이미지가 캐시에 있습니다")
            completion(cachedImage)
            return
        } else {
            print("이미지가 캐시에 없습니다")
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                imageCache.setImage(image, forKey: key)
                completion(image)
            }.resume()
        }
    }
}
