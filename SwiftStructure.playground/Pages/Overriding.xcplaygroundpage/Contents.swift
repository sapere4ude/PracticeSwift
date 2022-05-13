//: [Previous](@previous)

import Foundation

class Human {
    
    // 저장프로퍼티
    var name = "Kant"
    
    // 연산프로퍼티
    var computeProperty: String {
        return self.name + "For ComputeProperty"
    }
    
    func description() {
        print("나는 사람입니다.")
    }
}

class Teacher: Human {
    
    var alias = "KantTest"
    
    // 저장프로퍼티 (getter/setter가 모두 구현되어있어야 사용가능함)
    override var name: String {
        get {
            return self.alias
        } set {
            self.alias = newValue
        }
    }
    override func description() {   // Human에서 정의된 메서드에 override 키워드 사용
        super.description()
        print("나는 선생입니다.")
    }
    
    // 연산프로퍼티
    override var computeProperty: String {
        get {
            return self.name + "멍청이"
        } set {
            self.name = newValue
        }
    }
}

let kant: Teacher = .init()
kant.description()  // 나는 선생입니다.


let human: Human = .init()
human.name
human.computeProperty

let teacher: Teacher = .init()
teacher.name
teacher.computeProperty

//: [Next](@next)
