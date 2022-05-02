//
//  APIResponse.swift
//  ExDownloadImageTest
//
//  Created by Kant on 2022/05/02.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
}
