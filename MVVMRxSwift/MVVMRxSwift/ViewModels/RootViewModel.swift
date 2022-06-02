//
//  RootViewModel.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import Foundation

final class RootViewModel {
    let title = "jaejun"
    
    private let articleService:ArticleServiceProtocol
    
    init(articleService: ArticleServiceProtocol){
        self.articleService = articleService
    }
}
