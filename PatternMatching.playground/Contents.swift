import UIKit

enum NetworkResult {
    case success(Data)
    case failure(Error)
}


func handleNetworkResult(_ result: NetworkResult) {
    if case .success(let data) = result {
        print("Data received: \(data)")
    } else if case .failure(let error) = result {
        print(#fileID, #function, #line, "Error: \(error.localizedDescription)")
    }
}

func fetchData(completion: (NetworkResult) -> Void) {
    
    let success = true // 데이터를 얻어왔다고 가정
    
    if success {
        let data = Data()
        completion(.success(data))
    } else {
        let error = NSError(domain: "NetworkError", code: 1)
        completion(.failure(error))
    }
}

fetchData { result in
    handleNetworkResult(result)
}

enum T1 {
    case top(name: String, years: Int)
    case jungle(name: String, years: Int)
    case mid(name: String, years: Int)
    case ad(name: String, years: Int)
    case support(name: String, years: Int)
}

let zeus = T1.top(name: "최우제", years: 4)
let oner = T1.jungle(name: "문현준", years: 4)
let faker = T1.mid(name: "이상혁", years: 12)
let gumayusi = T1.ad(name: "이민형", years: 5)
let keria = T1.support(name: "류민석", years: 5)

if case let T1.mid(name: name, years: years) = faker {
    print("미드라이너의 이름은 \(name), 경력은 \(years)년 입니다.")
}



//enum Band {
//    case vocal(name: String, years: Int)
//    case drum(name: String, years: Int)
//    case guitar(name: String, years: Int)
//}
//
//let kant = Band.guitar(name: "칸쵸", years: 0)
//let aimyon = Band.vocal(name: "아이묭", years: 10)
