//
//  RequestAPI.swift
//  RandomImage
//
//  Created by Kant on 5/4/24.
//

import Combine
import Foundation

protocol Requestable {
    func getUrlRequest() -> AnyPublisher<RequestModel, any Error>
}

class RequestAPI: Requestable {
    func getUrlRequest() -> AnyPublisher<RequestModel, any Error> {
        let randomNumber = Int.random(in: 1...100)
        let url = URL(string: "https://picsum.photos/id/\(randomNumber)/info")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map( { $0.data })
            .decode(type: RequestModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct RequestModel: Decodable {
    let author: String
    let download_url: String
}
