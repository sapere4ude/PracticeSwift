//
//  TimerViewController.swift
//  ExWeakReference
//
//  Created by Kant on 11/6/23.
//

import UIKit

class TimerViewController: UIViewController {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("open timer VC", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var timer = Timer()
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        configureUI()
        timerButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: 메모리 누수때문에 deinit 이 불리지 않을 경우도 존재한다.
    deinit {
        print(#fileID, #function, #line, "칸트")
    }
    
    func configureUI() {
        
        view.addSubview(timeLabel)
        view.addSubview(timerButton)
        
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 200),
            timeLabel.heightAnchor.constraint(equalToConstant: 150),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timerButton.widthAnchor.constraint(equalToConstant: 200),
            timerButton.heightAnchor.constraint(equalToConstant: 150),
            timerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
    }
    
    @objc
    func startButtonTapped(_ sender: UIButton) {
        // MARK: 메모리 누수 발생 코드. 원인은 target > self
        /*timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)*/
        
        // MARK: 메모리 누수 해결
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.seconds += 1
            self?.timeLabel.text = String(self?.seconds ?? 0)
        }
    }

    @objc func updateTimer() {
        seconds += 1
        timeLabel.text = String(seconds)
    }
}
