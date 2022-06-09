import UIKit
import RxSwift

public func example(of description: String, action:()->Void) {
    print("\n---Example of:", description,"---")
    action()
}

example(of: "just,of,from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable<Int>.just(one)
}

example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one,two,three)
    
    observable.subscribe { event in
        //print(event) // next(1), next(3), next(3)
    }
    
    observable.subscribe(onNext: { element in
        print(element) // 1, 2, 3
    })
}


