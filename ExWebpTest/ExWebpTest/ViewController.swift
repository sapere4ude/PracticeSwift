//
//  ViewController.swift
//  ExWebpTest
//
//  Created by kant on 2022/07/25.
//

import UIKit
import SDWebImageWebPCoder
import Kingfisher
import KingfisherWebP

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SDWebImage
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
        SDWebImageDownloader.shared.setValue("image/webp,image/*,*/*;q=0.8", forHTTPHeaderField:"Accept")
        let urlPath = Bundle.main.url(forResource: "webpTest", withExtension: "webp")
        let webpURL:URL = urlPath!
//        imageView.sd_setImage(with: webpURL)
        
        
        // Kingfisher
        imageView.loadImage(url: webpURL, placeholder: nil)
        imageView.layer.zPosition =  1000
        imageView2.loadImage(url: webpURL, placeholder: nil)
        
    }
}

extension UIImageView {
    
    func loadImage(urlString: String?,
                   placeholder: UIImage?,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        
        let url = URL(string: urlString ?? "")
        loadImage(url: url, placeholder: placeholder, showIndicator: showIndicator, forceRefresh: forceRefresh, completion: completion)
    }
    
    func loadImage(url: URL?,
                   placeholder: UIImage?,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        var options: KingfisherOptionsInfo = [.transition(.fade(0.1)),
                                              .forceRefresh,
                                              .processor(WebPProcessor.default)]
        if forceRefresh {
            options.append(.forceRefresh)
        }
        self.kf.setImage(with: url, placeholder: placeholder, options: options, completionHandler: { result in
            switch result {
            case .success(let result):
                completion?(result.image, nil, result.source.url)
            case .failure(let err):
                completion?(nil, err, url)
            }
        })
    }
}

