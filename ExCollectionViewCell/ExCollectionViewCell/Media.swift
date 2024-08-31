//
//  Media.swift
//  ExCollectionViewCell
//
//  Created by Kant on 8/31/24.
//

import Foundation

struct Media: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let name: String
    let videos: [Video]
}

struct Video: Codable {
    let description: String
    let sources: [String]
    let subtitle: String
    let thumb: String
    let title: String
    
    // 추가된 상태 관리 프로퍼티
    var isFold: Bool = false
    //var currentTime: CMTime = .zero
}
