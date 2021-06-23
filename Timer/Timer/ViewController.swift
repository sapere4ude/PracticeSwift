//
//  ViewController.swift
//  Timer
//
//  Created by Kant on 2021/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerButton.layer.cornerRadius = 8
        timerButton.backgroundColor = .black
        timerButton.setTitle("타이머 시작하기", for: .normal)
        timerButton.tintColor = .white
        self.updateSecondsLabel()
    }
    
    var timer: Timer?
    var secondsLeft = 180   // 남아있는 시간 체크
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        self.resetTimer()
        self.segmentValueUpdate()
    }
    
    func segmentValueUpdate() {
        var check = segmentControl.selectedSegmentIndex
        if check == 0 {
            self.secondsLeft = 180
            self.timerLabel.text = "03:00"
        } else if check == 1 {
            self.secondsLeft = 240
            self.timerLabel.text = "04:00"
        } else {
            self.secondsLeft = 600
            self.timerLabel.text = "10:00"
        }
    }
    
    @IBAction func timerButtonClicked(_ sender: Any) {
        if timer != nil {
            self.resetTimer()
            self.timerButton.setTitle("타이머 시작하기", for: .normal)
            self.segmentValueUpdate()
            return
        }
        
        self.timerButton.setTitle("타이머 종료하기", for: .normal)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            self.secondsLeft -= 1
            self.updateSecondsLabel()
            
            if self.secondsLeft == 0 {
                self.resetTimer()
                self.updateSecondsLabel()
            }
        })
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timerButton.setTitle("타이머 시작하기", for: .normal)
    }
    
    func updateSecondsLabel() {
        var minutes = self.secondsLeft / 60
        var seconds = self.secondsLeft % 60
        
        if self.secondsLeft < 60 {
            self.timerLabel.textColor = UIColor(red: 0.94, green: 0.07, blue: 0.07, alpha: 1.00)
        } else {
            self.timerLabel.textColor = UIColor.black
        }
        
        
        UIView.transition(with: self.timerLabel, duration: 0.3, options: .curveEaseInOut) {
            if self.secondsLeft > 0 {
                self.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            } else {
                self.timerLabel.text = "시간 끝!"
            }
        }
    }
}

