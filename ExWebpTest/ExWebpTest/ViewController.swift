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

/*
 webp 파일을 보여줘야할 일이 생겼는데 어떤 라이브러리를 사용해야 좋을지 테스트하다가
 SDwebImageWebPCoder / KingfisherWebP 를 알게되었고 이를 정리했음
*/

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
        
        
        imageView2.sd_setImage(with: webpURL, placeholderImage: nil, options: [ SDWebImageOptions.lowPriority]) { (image, error, cacheType, url) in
            if error != nil{
                print("Success")
                
                // image 객체 안에 duration:2.965 로 설정되어있는걸 확인했기 때문에
                // 이미지 반복을 날리기 위해서 2.8초 이후엔 뷰에서 제거될 수 있게 했음.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                    self.imageView2.removeFromSuperview()
                }
            }
        }
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

