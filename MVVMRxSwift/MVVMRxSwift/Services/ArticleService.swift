//
//  ArticleService.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import Foundation
import Alamofire
import RxSwift


// 튜토리얼 4 부터 시작
protocol ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]>
}

// Alamofire 를 이용한 비동기처리는 콜백함수를 사용해야 한다.
// 하지만 RxSwift 를 사용하면 이러한 수고를 덜 수 있다.

class ArticleService: ArticleServiceProtocol {
    
    func fetchNews() -> Observable<[Article]> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchNews { (error, articles) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let articles = articles {
                    observer.onNext(articles)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func fetchNews(completion:@escaping((Error?, [Article]?) -> Void)) {
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2022-05-05&sortBy=publishedAt&apiKey=4927a1a645a249c489e248bf460cf4b4"
        guard let url = URL(string: urlString) else { return completion(NSError(domain: "jaejun", code: 404, userInfo: nil), nil)}
        
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: ArticleResponse.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            
            if let articles = response.value?.articles {
                return completion(nil, articles)
            }
            
        }
    }
}
