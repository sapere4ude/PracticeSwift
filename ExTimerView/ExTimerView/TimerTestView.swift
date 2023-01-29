//
//  TimerTestView.swift
//  ExTimerView
//
//  Created by kant on 2023/01/29.
//

import Foundation
import UIKit
import Combine


class TimerTestView: UIView {
    
    var subscriptions = Set<AnyCancellable>()
    
    private var currentTime: TimeInterval = 0.0
    
    let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let customLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let counter = TestCounter(max: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(customView)
        self.addSubview(customLabel)
        
        customView.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        customLabel.frame = CGRect(x: 200, y: 300, width: 100, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTimer() {
        print(#fileID, #function, #line, "칸트")
        counter.secondString
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: self.customLabel)
            .store(in: &subscriptions)
        
        counter.killedEvent
            .sink(receiveValue: {
//                self.removeFromSuperview()
                self.layer.opacity = 0.5
            }).store(in: &subscriptions)
        
        counter.restartedEvent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                print(#fileID, #function, #line, "- restartedEvent")
                self.layer.opacity = 1
            }).store(in: &subscriptions)
    }
    
    func restart(){
        print(#fileID, #function, #line, "- ")
        self.layer.opacity = 1
        counter.restart()
    }
}

class TestCounter: ObservableObject {

    //Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var killedEvent = PassthroughSubject<(), Never>()
    var restartedEvent = PassthroughSubject<(), Never>()
    
    @Published fileprivate var currentTimePublisher: TimeInterval = 0.0
    
    lazy var secondString : AnyPublisher<String, Never> = $currentTimePublisher.map{ String($0) }.eraseToAnyPublisher()
    
    private var timer: Timer?
    
    var timerCancellable : AnyCancellable? = nil
    
    let maxCount : Double
    
    init(max: Double) {
        self.maxCount = max
         
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
            //.makeConnectable() <- 이게 있으면 타이머가 바로 시작되지 않음
            .autoconnect()
        
        timerCancellable = timerPublisher
            .sink { _ in
                self.currentTimePublisher += 1
                print(#fileID, #function, #line, "self.currentTimePublisher: \(self.currentTimePublisher)")
                if self.currentTimePublisher == max {
                    self.kill()
                }
            }
    }
    
    func restart(){
        restartedEvent.send()
        reset()
        kill()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.currentTimePublisher += 1
                print(#fileID, #function, #line, "self.currentTimePublisher: \(self.currentTimePublisher)")
                if self.currentTimePublisher == self.maxCount {
                    self.kill()
                }
            }
    }
//
    func kill(){
//        self.timer?.invalidate()
//        self.timer = nil
        timerCancellable?.cancel()
        timerCancellable = nil
        killedEvent.send(())
    }
    
    func reset(){
        currentTimePublisher = 0
    }
    
    deinit {
        print(#fileID, #function, #line, "칸트 deinit")
    }
}

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(to path: ReferenceWritableKeyPath<Root, Output?>, on instance: Root) -> Cancellable {
        sink { instance[keyPath: path] = $0 }
    }
}
