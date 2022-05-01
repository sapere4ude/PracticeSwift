//
//  ViewController.swift
//  ExDownloadImageTest
//
//  Created by Kant on 2022/04/30.
//

import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
}

class ViewController: UIViewController {
    
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    
    private let reuseIdentifier = "ImageCell"
    
    private let cellSpacing: CGFloat = 1
    private let colums: CGFloat = 3
    
    private var urls:[URL] = []
    
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=7ysPfVRz1xbctEHT5WXFwdKrscSbM2lINft44R47CsM"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("데이터를 얻었습니다")
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResult.results.count)
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    
}

