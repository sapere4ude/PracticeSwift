//
//  MicManager.swift
//  ExMicDecibel
//
//  Created by Kant on 2021/12/21.
//

import Foundation
import AVKit

protocol MicManagerDelegate {
    func audioRecordingFailed()
    func avgAudioVolumeResult(_ value: Double)
    func peakAudioVolumeResult(_ value: Double)
}

class MicManager: NSObject {
    let audioSession = AVAudioSession.sharedInstance()
    var delegate: MicManagerDelegate?
    private let audioEngine = AVAudioEngine()

    private var recorder : AVAudioRecorder? = nil
    private var timer: Timer?
    var interval: Double = 0.2

    func getDocumentsDirectory() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls.first!
        return documentDirectory.appendingPathComponent("recording.m4a")
    }
    
    var isAudioEngineRunning: Bool {
        return self.recorder?.isRecording == true
    }
    
    func checkForPermission(_ result: @escaping (_ success: Bool)->()) {
        switch audioSession.recordPermission {
        case .granted:
            initRecorder()
            result(true)
        case .denied: result(false)
        case .undetermined:
            audioSession.requestRecordPermission { _ in
                self.checkForPermission(result)
            }
        }
    }

    func initRecorder() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try session.setActive(true)
            
            try recorder = AVAudioRecorder(url: getDocumentsDirectory(), settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            if recorder?.prepareToRecord() != true {
                print("Error: AVAudioRecorder prepareToRecord failed")
            }
        } catch {
            print("Error: AVAudioRecorder creation failed")
        }
    }
    
    func startRecording() {
        recorder?.record()
        startTimer()
    }
    
    func stopRecording() {
        timer?.invalidate()
        recorder?.stop()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.getDispersyPercent), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func getDispersyPercent() {
        recorder?.updateMeters()
        let db = Double(recorder?.averagePower(forChannel: 0) ?? -160)
        let result = pow(10.0, db / 20.0)
        print("result: \(result)")
        
        delegate?.avgAudioVolumeResult(result)
        
        /*
         result: 0.045281349464066215
         result: 0.017804956791199925
         result: 0.008449389538119224
         result: 0.13473403313868873
         result: 0.048031282314639594
         result: 0.019675417210520657
         result: 0.5718879408092349
         */
        
        let db2 = Double(recorder?.peakPower(forChannel: 0) ?? -160)
        let result2 = pow(10.0, db2 / 20.0)
        delegate?.peakAudioVolumeResult(result2)
    }
    
    private func normalizeSoundLevel(level: Float) -> Float {
        // 화면에 표시되는 rawSoundLevel 기준
        // white noise만 존재할 때의 값을 lowLevel 에 할당
        // 가장 큰 소리를 냈을 때 값을 highLevel 에 할당
        
        let lowLevel: Float = -50
        let highLevel: Float = -10
        
        var level = max(0.0, level - lowLevel) // low level이 0이 되도록 shift
        level = min(level, highLevel - lowLevel) // high level 도 shift
        // 이제 level은 0.0 ~ 40까지의 값으로 설정 됨.
        return level / (highLevel - lowLevel) // scaled to 0.0 ~ 1
    }
}

extension MicManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recorder.stop()
        recorder.deleteRecording()
        recorder.prepareToRecord()
    }
}
