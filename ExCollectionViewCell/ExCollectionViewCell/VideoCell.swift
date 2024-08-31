//
//  VideoCell.swift
//  ExCollectionViewCell
//
//  Created by Kant on 8/31/24.
//

import UIKit
import Foundation
import AVFoundation

protocol VideoCellDelegate: AnyObject {
    func updateVideoState(_ video: Video)
}

final class VideoCell: UICollectionViewCell {

    private var video: Video?
    weak var delegate: VideoCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(systemName: "play.fill")
        button.setImage(playImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var videoURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setupPlayerLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if var video = video {
//            video.isPlaying = player?.rate != 0
//            video.currentTime = player?.currentTime() ?? .zero
            delegate?.updateVideoState(video)
        }
    }
    
    private func setupUI() {
        contentView.addSubview(videoContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        //contentView.addSubview(playButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            videoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            videoContainerView.widthAnchor.constraint(equalToConstant: 200),
            videoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: 10),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: 10),
//            playButton.widthAnchor.constraint(equalToConstant: 38),
//            playButton.heightAnchor.constraint(equalToConstant: 38),
//            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with video: Video) {
        titleLabel.text = video.title
        subtitleLabel.text = video.subtitle
        
        if let sources = video.sources.first,
           let url = URL(string: sources) {
            configure(with: url)
        }
    }
    
    func configure(with url: URL) {
        self.videoURL = url
        
        // TODO: - 성능 차이 테스트하기
        
        DispatchQueue.main.async {
            self.playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: self.playerItem)
            
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame = self.videoContainerView.bounds
            self.playerLayer?.videoGravity = .resizeAspectFill
            
            if let playerLayer = self.playerLayer {
                self.videoContainerView.layer.addSublayer(playerLayer)
            }
        }
        
//        Task { @MainActor in
//            self.playerItem = AVPlayerItem(url: url)
//            self.player = AVPlayer(playerItem: self.playerItem)
//            
//            self.playerLayer = AVPlayerLayer(player: self.player)
//            self.playerLayer?.frame = self.videoContainerView.bounds
//            self.playerLayer?.videoGravity = .resizeAspectFill
//            
//            if let playerLayer = self.playerLayer {
//                self.videoContainerView.layer.addSublayer(playerLayer)
//            }
//        }
    }
}
