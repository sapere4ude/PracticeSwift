//
//  AdPlayer+PlayerSetting.swift
//  ExAdPlayer
//
//  Created by Kant on 2/10/24.
//

import UIKit
import Foundation
import AVFoundation

protocol PlayerConfigurable: AnyObject {
    func prepareUI()
}

extension AdPlayer {

    func prepareToPlay(url: URL,
                       seekTime: CMTime = CMTimeMake(value: 0, timescale: 1),
                       videoGravity :AVLayerVideoGravity = .resize,
                       isMute: Bool = false) {
        
        DispatchQueue.global().async {
            guard self.videoURL?.absoluteString != url.absoluteString else { return }
            self.videoURL = url
            let playerItem = AVPlayerItem(url: url)
            playerItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
            let player = AVPlayer(playerItem: playerItem)
            
            DispatchQueue.main.async {
                self.player = player
                self.initPlayerLayer(videoGravity: videoGravity)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem,
               playerItem.status == .readyToPlay {
                DispatchQueue.main.async {
                    self.delegate?.prepareUI()
                }
            }
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
}
