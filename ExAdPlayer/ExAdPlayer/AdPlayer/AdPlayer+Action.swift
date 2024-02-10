//
//  AdPlayer+Action.swift
//  ExAdPlayer
//
//  Created by Kant on 2/10/24.
//

import Foundation

extension AdPlayer {
    
    func play() {
        pauseAction = false
        self.player.play()
    }
    
    func pause() {
        pauseAction = true
        self.player.pause()
    }
    
    func showSkipButton() {
        skipButton.isHidden = false
        skipButton.isAccessibilityElement = true
        remainingTimeToSkipLabel.isHidden = true
        remainingTimeToSkipLabel.isAccessibilityElement = false
    }
    
    func showRemainingTimeToSkipLabel() {
        remainingTimeToSkipLabel.isHidden = false
        remainingTimeToSkipLabel.isAccessibilityElement = true
        skipButton.isHidden = true
        skipButton.isAccessibilityElement = false
    }
    
    @objc
    func didTapTouchButton() {
        onTouch?()
    }
    
    @objc
    func didTapSkipButton() {
        onSkipped?()
    }
    
    @objc
    func videoAdFinish(_ notification: Notification) {
        onClose?()
    }
}
