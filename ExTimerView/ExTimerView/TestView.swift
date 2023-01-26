//
//  TestView.swift
//  ExTimerView
//
//  Created by kant on 2023/01/26.
//

import UIKit
import Combine
import Foundation

class TestView: UIView {
    
    var subscriptions = Set<AnyCancellable>()
    
    private var currentTime: TimeInterval = 0.0
    var counter = Counter(Δt: 1)
    
    let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let customLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(customView)
        self.addSubview(customLabel)
        
        customView.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        customLabel.frame = CGRect(x: 200, y: 300, width: 100, height: 100)
        
        counter.$currentTimePublisher
            .receive(on: RunLoop.main)
            .sink { (seconds) in
             print("Seconds: \(seconds)")
                if seconds > 10.0 {
                    self.counter.kill()
                    self.removeFromSuperview()
                }
                self.customLabel.text = String(seconds)
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Counter: ObservableObject {

    @Published var currentTimePublisher: TimeInterval = 0.0
    
    private var timer: Timer?
    
    init(Δt: Double) {
        self.timer = Timer.scheduledTimer(withTimeInterval: Δt, repeats: true) { _ in
            self.currentTimePublisher += 1
            print(#fileID, #function, #line, "칸트")
        }
    }
    
    func restart(Δt: Double){
        kill()
        self.timer = Timer.scheduledTimer(withTimeInterval: Δt, repeats: true) { _ in
            self.currentTimePublisher += 1
        }
    }
    
    func kill(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func reset(){
        currentTimePublisher = 0
    }
}