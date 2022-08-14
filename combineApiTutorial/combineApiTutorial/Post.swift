//
//  Post.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

