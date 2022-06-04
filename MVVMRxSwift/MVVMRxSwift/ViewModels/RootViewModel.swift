//
//  RootViewModel.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import Foundation
import RxSwift

final class RootViewModel {
    let title = "jaejun"
    
    private let articleService:ArticleServiceProtocol // 타입을 프로토콜로 갖고있는것이 확장성이 좋다
    
    init(articleService: ArticleServiceProtocol){
        self.articleService = articleService
    }
    
    func fetchArticles() -> Observable<[ArticleViewModel]> { // 많이 쓰이는 패턴이므로 알아둘것!
        return articleService.fetchNews().map { $0.map { ArticleViewModel(article: $0)}} 
    }
}
