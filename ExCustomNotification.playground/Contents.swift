import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

NotificationCenter.default.addObserver(self, selector: #selector(sampleTest), name: Notification.Name("CustomNoti"), object: nil)

@objc func sampleTest() {
    print("called sample Test")
}

NotificationCenter.default.post(name: Notification.Name("CustomNoti"), object: self)

NotificationCenter.default
    .publisher(for: Notification.Name("CustomNoti"))
    .sink(receiveCompletion: { _ in
        print("completion")
    }, receiveValue: { _ in
        print("combine button click") } // tapped 함수의 역할이 종료될 때 호출된다.
    )
    .store(in: &cancellableBag)


 
