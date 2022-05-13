//: [Previous](@previous)

import Foundation

// 조건문에서 제공하는 unwrapping 을 사용하지 않은 경우
var something: Bool? = true

if let unwrappedSomething = something, unwrappedSomething {
    print("true something")
} else {
    print("false something")
}

// 조건문에서 제공하는 unwrapping 을 사용한 경우
// something이 옵셔널 타입이라도 자동으로 unwrapping 해준다.
if something == true {
    print("true something")
} else {
    print("false something")
}

// Bool 타입이 아닌 다른 타입이여도 적용 가능하다
var integerValue: Int? = 1

if integerValue == 1 {
    print("integerValue is One")
} else {
    print("integerValue isn't One")
}

// 값이 nil이면 else를 실행함
var somethingNil: Bool? = nil

if somethingNil == true {
    print("somethingNil is true")
} else {
    print("somethingNil is false")
}

// switch문에서 제공하는 unwrapping
// 값이 1인 경우
switch integerValue {
case 1:
    print("Value is One")
case .none:
    print("Value is nil")
default:
    print("Value isn't One")
}

// 값이 nil인 경우
var intValue: Int? = nil

switch intValue {
case 1:
    print("Value is One")
case .none:
    print("Value is nil")
default:
    print("Value isn't One")
}


//: [Next](@next)
