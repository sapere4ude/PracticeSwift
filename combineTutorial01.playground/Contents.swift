import UIKit
import Combine

var myPublisher: Publishers.Sequence<[Int], Never> = [1,2,3].publisher

//myPublisher.sink { completion in
//    switch completion {
//    case .finished:
//        print("완료")
//    case .failure(let error):
//        print("실패, error: \(error)")
//    }
//} receiveValue: { receivedValue in
//    print("값을 받았다 -> \(receivedValue)")
//}

var myNotification = Notification.Name("com.kant.customNotification")

var myDefaultPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: myNotification)

// post <- 구독하는 행위라 보면 됨
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))
