//
//  ViewController.swift
//  ExAppLifeCycle
//
//  Created by Kant on 2022/09/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupObserver()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLaunchingNotification), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminateNotification), name: UIApplication.willTerminateNotification, object: nil)
    }

    // 앱이 inactive 상태였다가 active 상태가 될때 찍히게 된다.
    //
    @objc func didBecomeActiveNotification() {
        print(#function)
    }
        
    @objc func didEnterBackgroundNotification() {
        print(#function)
    }
        
    @objc func willEnterForegroundNotification() {
        print(#function)
    }
    
    // 사실 resign 상태가 무엇인지 정확히 알지 못했음.
    // 현재 사용중인 앱이 어떤 것인지 파악할때 보게 되는 화면이 resignActive 상태였음.
    // 이 상태에서 다시 앱으로 진입하게 된다면? didBecome
    @objc func willResignActiveNotification() {
        print(#function)
    }
        
    @objc func didFinishLaunchingNotification() {
        print(#function)
    }
    
    @objc func willTerminateNotification() {
        print(#function)
    }
}

