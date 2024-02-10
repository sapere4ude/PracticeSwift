//
//  AdPlayer+PlayerSetting.swift
//  ExAdPlayer
//
//  Created by Kant on 2/10/24.
//

import UIKit
import Foundation
import AVFoundation

extension AdPlayer {
    
    // MARK: - 미디어 셋팅
    func prepareToPlay(url: URL,
                       seekTime: CMTime = CMTimeMake(value: 0, timescale: 1),
                       videoGravity :AVLayerVideoGravity = .resizeAspect,
                       isMute: Bool = false) {
        
        guard self.videoURL?.absoluteString != url.absoluteString else {
            return
        }
        
        self.resetPlayer()
        self.videoURL = url
        self.asset = AVAsset(url: url)
        self.playerItem = AVPlayerItem(asset: self.asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.player.isMuted = isMute
        self.initPlayerLayer(videoGravity: videoGravity)
        
        if seekTime.value != 0 && seekTime.timescale != 1 {
            self.player.seek(to: seekTime)
            loadSeekTime = seekTime
        }
        else {
            loadSeekTime = nil
        }
    }
    
    private func initPlayerLayer(videoGravity :AVLayerVideoGravity) {
        if let playerLayer = self.playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.needsDisplayOnBoundsChange = true
        self.playerLayer?.frame = self.bounds
        self.playerLayer?.videoGravity = videoGravity
        self.layer.addSublayer(self.playerLayer!)
    }
    
    func resetPlayer() {
        if let playerLayer = self.playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        self.videoURL = nil
        self.playerItem = nil
    }
    
    public func load(for model: AdModel?) {
  
        let url = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        
        prepareToPlay(url: url)
        player.play()
        setupUI()
    }
}
