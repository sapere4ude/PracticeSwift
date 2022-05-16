//
//  ViewController.swift
//  Request
//
//  Created by Kant on 2021/07/17.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET 방식
        request("http://localhost:5000/test/get", "GET") { (success, data) in
            print(data)
        }
        
        // POST 방식. 필수적으로 던져줘야할 값들을 param 에 넣어서 서버에 요청을 넣는 것이 특징
        request("http://localhost:5000/test/post", "POST", ["key": "hello!"]) { (success, data) in
          print(data)
        }
    }
}

