//
//  UITapGesture+Extension.swift
//  ExCustomPublisher
//
//  Created by kant on 2022/12/19.
//

import UIKit
import Combine

extension UITapGestureRecognizer {
  struct GesturePublisher<TapRecognizer: UITapGestureRecognizer>: Publisher {
    typealias Output = TapRecognizer
    typealias Failure = Never
    
    private let recognizer: TapRecognizer
    private let view: UIView
    
    init(recognizer: TapRecognizer, view: UIView) {
      self.recognizer = recognizer
      self.view = view
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, TapRecognizer == S.Input {
      let subscription = GestureSubscription(
        subscriber: subscriber,
        recognizer: recognizer,
        view: view
      )
      subscriber.receive(subscription: subscription)
    }
  }
}

extension UITapGestureRecognizer {
  final class GestureSubscription<S: Subscriber, TapRecognizer: UITapGestureRecognizer>: Subscription
  where S.Input == TapRecognizer {
    private var subscriber: S?
    private let recognizer: TapRecognizer
    
    init(subscriber: S, recognizer: TapRecognizer, view: UIView) {
      self.subscriber = subscriber
      self.recognizer = recognizer
      recognizer.addTarget(self, action: #selector(eventHandler))
      view.addGestureRecognizer(recognizer)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
      subscriber = nil
    }
    
    @objc func eventHandler() {
      _ = subscriber?.receive(recognizer)
    }
  }
}
