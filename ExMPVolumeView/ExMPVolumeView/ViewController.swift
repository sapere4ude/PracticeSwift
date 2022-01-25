//
//  ViewController.swift
//  ExMPVolumeView
//
//  Created by Kant on 2022/01/25.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!

    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenVolumeButton()
    }
    
    func listenVolumeButton() {
        do {
            try audioSession.setActive(true)
        } catch {}
        
        outputVolumeObserve = audioSession.observe(\.outputVolume) { (audioSession, changes) in
            self.slider.value = audioSession.outputVolume
        }
    }
}
