//
//  AdPlayer+UI.swift
//  ExAdPlayer
//
//  Created by Kant on 2/10/24.
//

import UIKit
import AVFoundation

// MARK: - UI
extension AdPlayer {
    internal func setupUI() {
        self.addSubview(backButton)
        self.addSubview(playTimeLabel)
        self.addSubview(remainingTimeToSkipLabel)
        self.accessibilityElements = [backButton, playTimeLabel, touchButton, skipButton, remainingTimeToSkipLabel]
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            playTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            playTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 35),
            playTimeLabel.heightAnchor.constraint(equalToConstant: 12),
            
            remainingTimeToSkipLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 42),
            remainingTimeToSkipLabel.heightAnchor.constraint(equalToConstant: 30),
            remainingTimeToSkipLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            remainingTimeToSkipLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    private func setupPlayer() {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.frame = self.bounds
        self.playerLayer = playerLayer
        self.layer.addSublayer(playerLayer)
    }
}
