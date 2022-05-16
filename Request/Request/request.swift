//
//  request.swift
//  Request
//
//  Created by Kant on 2021/07/17.
//

import UIKit

// Codable 을 사용하면 JSON 객체를 Dictionary 형태로 만들 수 있다.
struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}

/* Body가 없는 요청 */
func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
    
    // 1. url 객체 생성
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    // 2. request 객체 생성
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // 3. URLSession 을 이용한 데이터 요청
    // 실행되는 순서를 확인할 필요가 있다. 결론적으로 말하면 URLSession.shared.dataTask(with: request) 의 실행이
    // 완료되면 서버로부터 data, response, error 에 대한 값을 전받게 된다. 이후  trailing closure 로 작성된
    // { data, response, error in } 의 코드가 실행된다.
    // dataTask 의 definition 을 따라가면 completionHandler 가 @escaping으로 구성된 것을 확인할 수 있다.
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        // data 객체에 서버로부터 전달받은 값이 저장되어 있다. 서버로부터 전달받은 값은 Encoding 되어있기 때문에
        // Decoding 작업이 필요하다. 그걸 가능하게 하는 것이 JSONDecoder().decode 이다.
        // 정상적으로 값을 전달받게 되면 그것은 Response 구조체의 형식을 띄게 된다. 그렇기 때문에 output.result 이런식으로
        // 호출하는 것이 가능해진다.
        guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        // 위의 과정에서 통해 얻은 것을 requestGet을 호출한 코드에 알려준다.
        completionHandler(true, output.result)
    }.resume()
}

/* Body가 있는 요청 */
func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
    
    // JSONSerialization 의 역할: JSON <-> Array || Dictionary
    
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
    
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = sendData
    
    // request 객체에 내가 요구하는걸 담아서 URLSession 을 실행한다.
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }
        
        completionHandler(true, output.result)
    }.resume()
}


/* 메소드별 동작 분리 */
func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
    if method == "GET" {
        requestGet(url: url) { (success, data) in
            completionHandler(success, data)
        }
    }
    else {
        requestPost(url: url, method: method, param: param!) { (success, data) in
            completionHandler(success, data)
        }
    }
}
