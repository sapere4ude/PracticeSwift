//
//  Todo.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import Foundation

// MARK: - TodoElement
struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
