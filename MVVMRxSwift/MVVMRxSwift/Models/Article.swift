//
//  Article.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import Foundation

// 데이터 fetching 준비 완료

struct ArticleResponse: Codable {
    let status: String?
    let totalResults: Int
    let articles:[Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let descrition: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
