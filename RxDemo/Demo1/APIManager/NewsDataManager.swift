//
//  NewsDataManager.swift
//  RxDemo
//
//  Created by Janzen on 2020/6/30.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

class NewsDataManager: NSObject {
    static let share = NewsDataManager()
    
    private let provider = MoyaProvider<MoyaAPI>()
    
    func getNews(_ offset: String) -> Observable<[NewsSections]> {
        return Observable<[NewsSections]>.create { [weak self] (observable:AnyObserver<[NewsSections]>) -> Disposable in
            self?.provider.request(.news(offset: offset), callbackQueue: DispatchQueue.main) { response in
                switch response {
                    case let .success(results):
                        let news: [NewsSections]! = self?.parse(results.data)
                        observable.onNext(news)
                        observable.onCompleted()
                    case let .failure(error):
                        observable.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
    func parse(_ data: Any) -> [NewsSections] {
        guard let json = JSON(data)["T1348649079062"].array else { return [] }
        
        var news: [NewsModel] = []
        
        json.forEach {
            guard !$0.isEmpty else { return }
            var imgnewextras: [Imgnewextra] = []
            if let imgnewextraJsonArray = $0["imgnewextra"].array {
                imgnewextraJsonArray.forEach {
                    let subItem = Imgnewextra(imgsrc: $0["imgsrc"].string ?? "")
                    imgnewextras.append(subItem)
                }
            }
            let new = NewsModel(title: $0["title"].string ?? "", imgsrc: $0["imgsrc"].string ?? "", replyCount: $0["replyCount"].string ?? "", source: $0["source"].string ?? "", imgnewextra: imgnewextras)
            
            news.append(new)
        }
        return [NewsSections(header: "1", items: news)]
    }
    
}

enum MoyaAPI {
    case news(offset: String)
}

extension MoyaAPI: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://c.m.163.com")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        return "/dlist/article/dynamic"
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case let .news(offset):
            let parameters = ["from": "T1348649079062", "devId": "H71eTNJGhoHeNbKnjt0%2FX2k6hFppOjLRQVQYN2Jjzkk3BZuTjJ4PDLtGGUMSK%2B55", "version": "54.6", "spever": "false", "net": "wifi", "ts": "\(Int(Date().timeIntervalSince1970))", "sign": "BWGagUrUhlZUMPTqLxc2PSPJUoVaDp7JSdYzqUAy9WZ48ErR02zJ6%2FKXOnxX046I", "encryption": "1", "canal": "appstore", "offset": offset, "size": "10", "fn": "3"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return ["Content-Type": "text/plain"]
    }
}
