//
//  ViewController.swift
//  ExCollectionViewCell
//
//  Created by Kant on 8/31/24.
//

import UIKit

class ViewController: UIViewController {
    
    var videos: [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
    }
    
    private func fetchData() {
        guard let path = Bundle.main.path(forResource: "mock", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else { return }
        
        if let media = try? JSONDecoder().decode(Media.self, from: data) {
            self.videos = media.categories.first?.videos
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell else {
            return UICollectionViewCell()
        }
        
        if let video = videos?[indexPath.row] {
            cell.configure(with: video)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ViewController: VideoCellDelegate {
    func updateVideoState(_ video: Video) {
        
    }
}
