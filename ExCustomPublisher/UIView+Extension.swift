//
//  UIView+Extension.swift
//  ExCustomPublisher
//
//  Created by kant on 2022/12/19.
//

import UIKit
import Combine

extension UIView {
  func throttleTapGesturePublisher() -> Publishers.Throttle<UITapGestureRecognizer.GesturePublisher<UITapGestureRecognizer>, RunLoop> {
    return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
      .throttle(
        for: .seconds(1),
        scheduler: RunLoop.main,
        latest: false
      )
  }
}
