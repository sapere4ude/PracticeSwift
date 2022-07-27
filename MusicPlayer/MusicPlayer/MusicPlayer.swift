//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Kant on 2022/07/24.
//

import UIKit
import AVFoundation

class MusicPlayer: NSObject {
    // singleton instance
    static let shared = MusicPlayer()
    @objc class func sharedInstance() -> MusicPlayer {
        return MusicPlayer.shared
    }
    
    var avPlayer: AVAudioPlayer?
    var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    
}
