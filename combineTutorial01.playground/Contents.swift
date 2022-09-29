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

var mySubscription: AnyCancellable?

var mySubscriptionSet = Set<AnyCancellable>()

var myNotification = Notification.Name("com.kant.customNotification")

var myDefaultPublisher: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: myNotification)

mySubscription = myDefaultPublisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("완료")
    case .failure(let error):
        print("실패, error: \(error)")
    }
}, receiveValue: { receivedValue in
    print("값을 받았다 -> \(receivedValue)")
})

mySubscription?.store(in: &mySubscriptionSet) // & <- in/out, 매개변수를 통해 값을 변경

// post <- 구독하는 행위라 보면 됨
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))

// KVO - Key Value Observing
class MyFriend {
    var name = "재준" {
        didSet {
            print("name - didSet() :", name)
        }
        willSet {
            print("name - willSet() :", name)
        }
    }
}

// 객체 생성시엔 재준으로 생성
var myFriend = MyFriend()

// '승이' 라는 이름을 구독
var myFriendSubscription: AnyCancellable = ["승이"].publisher.assign(to: \.name, on: myFriend)

