//
//  ViewController.swift
//  ExAudioSession
//
//  Created by Kant on 11/8/23.
//

import UIKit
import AVFoundation

// MARK: - 관련 이슈가 있어서 찾아봤던 문서
// https://developer.apple.com/library/archive/qa/qa1668/_index.html

final class ViewController: UIViewController {
    
    private var video: AVPlayer?
    private var videoLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupObserver()
        setupPlayer()
        playVideo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.videoLayer?.frame = view.bounds
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    private func setupPlayer() {
        let videoLayer = AVPlayerLayer(player: self.video)
        videoLayer.needsDisplayOnBoundsChange = true
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        videoLayer.frame = view.bounds
        self.videoLayer = videoLayer
        view.layer.addSublayer(videoLayer)
    }
    
    private func playVideo() {
        if let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4") {
            self.video = AVPlayer(url: videoURL)
            self.video?.play()
        }
    }
    
    @objc
    private func willEnterForeground() {
        videoLayer?.player = self.video
    }
    
    @objc
    private func didEnterBackground() {
        videoLayer?.player = nil
    }
}
