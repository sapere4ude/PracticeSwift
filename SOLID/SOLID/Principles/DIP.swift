//
//  DIP.swift
//  SOLID
//
//  Created by Kant on 2022/10/26.
//

// DIP(Dependency Inversion Principle) - 의존관계 역전 원칙

import Foundation

// Bad case
//class APIHandler {
//    func request() -> Data {
//        return Data(base64Encoded: "This Data")!
//    }
//}
//
//class LoginServiceTest {
//    let apiHandler: APIHandler = APIHandler()
//
//    func login() {
//        let loginData = apiHandler.request()
//        print(loginData)
//    }
//}

// Good case
protocol APIHandlerTestProtocol {
    func requestAPI() -> Data
}

class LoginServiceTest {
    let apiHandler: APIHandlerTestProtocol
    
    init(apiHandler: APIHandlerTestProtocol) {
        self.apiHandler = apiHandler
    }
    
    func login() {
        let loginData = apiHandler.requestAPI()
        print("login Data")
    }
}

class LoginAPI: APIHandlerTestProtocol {
    func requestAPI() -> Data {
        return Data(base64Encoded: "User")!
    }
}

let loginAPI = LoginAPI()
let loginService = LoginServiceTest(apiHandler: loginAPI)
loginService.login()


