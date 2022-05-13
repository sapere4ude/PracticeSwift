import Foundation

//func sum() {}
//func sum(n: Int) {}
//func sum() -> Int {return 0}


// 만일 오버로딩 기능이 없다면?
// 아래와 같이 각 타입별로 함수를 만들어주고 호출할때도 필요로 하는걸로 넣어줘야함
func sumInt(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func sumDouble(_ a: Double, _ b: Double) -> Double {
    return a + b
}

func sumString(_ a: String, _ b: String) -> String {
    return a + b
}

// 오버로딩 기능을 활용하면 호출할때 필요로 하는걸 찾을 필요없이 간결하게 사용할 수 있다.
func sum(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func sum(_ a: Double, _ b: Double) -> Double {
    return a + b
}

func sum(_ a: String, _ b: String) -> String {
    return a + b
}
