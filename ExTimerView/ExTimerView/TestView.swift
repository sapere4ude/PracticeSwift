//
//  TestView.swift
//  ExTimerView
//
//  Created by kant on 2023/01/26.
//

import UIKit
import Combine

class TestView: UIView {
    
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
        let counter = Counter(Δt: 1)

        counter.$currentTimePublisher
            .receive(on: RunLoop.main)
            .sink { (seconds) in
                print("Seconds: \(seconds)")
                if seconds > 10.0 {
                    print(#fileID, #function, #line, "칸트, 10초 넘었다")
                    counter.kill()
                    counter.reset()
                    self.removeFromSuperview()
                }
                self.customLabel.text = String(seconds)
            }
            .store(in: &subscriptions)
        
        // 애플 공식 문서
        // (https://developer.apple.com/documentation/combine/routing-notifications-to-combine-subscribers)
        NotificationCenter.default
                .publisher(for: UIDevice.orientationDidChangeNotification)
                .filter() { _ in UIDevice.current.orientation == .portrait }
                .sink() { _ in
                    print(#fileID, #function, #line, "칸트 portrait") }
                .store(in: &subscriptions)
        
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink() { _ in
                counter.restart(Δt: 1)
                print(#fileID, #function, #line, "칸트 appMovedToForeground") }
            .store(in: &subscriptions)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink() { _ in
                counter.kill()
                self.removeFromSuperview()
                print(#fileID, #function, #line, "칸트 didEnterBackgroundNotification") }
            .store(in: &subscriptions)
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
    
    deinit {
        print(#fileID, #function, #line, "칸트 deinit")
    }
}
