//
//  ArticleViewModel.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/04.
//

import Foundation

struct ArticleViewModel {
    private let article: Article
    
    var imageURL: String? {
        return article.urlToImage
    }
    var title: String? {
        return article.title
    }
    var description: String? {
        return article.descrition
    }
    
    init(article: Article) {
        self.article = article
    }
}
