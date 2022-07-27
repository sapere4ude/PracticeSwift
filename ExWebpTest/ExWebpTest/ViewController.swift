//
//  ViewController.swift
//  ExWebpTest
//
//  Created by kant on 2022/07/25.
//

import UIKit
import SDWebImageWebPCoder

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add coder
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
        
        SDWebImageDownloader.shared.setValue("image/webp,image/*,*/*;q=0.8", forHTTPHeaderField:"Accept")
        
        // WebP online image loading
        let webpURL:URL = URL(string: "https://www.gstatic.com/webp/gallery/1.webp")!
        imageView.sd_setImage(with: webpURL)
    }
}

