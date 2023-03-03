//
//  TodoModel.swift
//  ExMVVM+Combine
//
//  Created by kant on 2023/03/03.
//

import Foundation

struct TodoModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
