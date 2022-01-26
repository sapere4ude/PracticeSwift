//
//  ViewController.swift
//  ExMPVolumeView
//
//  Created by Kant on 2022/01/25.
//

import UIKit
import MediaPlayer
import AVFoundation
import StepSlider

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepSlider: StepSlider!
    
    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
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
//            self.stepSlider.index = UInt(round(audioSession.outputVolume * 10))

            let outputVolumeUpdate = (audioSession.outputVolume * 10).rounded()
            print("outputVolumeUpdate:\(outputVolumeUpdate)")
            self.stepSlider.index = UInt(outputVolumeUpdate)
        }
    }
    @IBAction func soundVolumeChange(_ sender: Any) {
        Self.setVolume(Float(self.stepSlider.index) * 0.1)
    }
}
