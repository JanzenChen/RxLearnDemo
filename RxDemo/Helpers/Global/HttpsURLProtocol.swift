//
//  HttpsURLProtocol.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

fileprivate let forgeroundHandledKey = "ForgeroundhandledKey"
fileprivate let backgroundHandledKey = "BackgroundHandledKey"
fileprivate let key_urlUpdateDic = "URLUpdateDictionary"

class HttpsURLProtocol: URLProtocol, URLSessionDataDelegate {
    
    private let forgeroundNetQueue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 10 // 前台请求最大线程数
        return queue
    }()
    
    private let backgroundNetQueue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 5 // 后台请求最大线程数
        return queue
    }()
    
    static var urlUpdateDic: [String?: Date]? = {
        return UserDefaults.standard.dictionary(forKey: key_urlUpdateDic) as? [String : Date] ?? nil
    }()
    
    static func saveUpdateDic() {
        UserDefaults.standard.set(urlUpdateDic, forKey: key_urlUpdateDic)
    }
    
    private let updateInterval: Double = 36000 // 更新时间间隔
    
    private var data: Data? = nil
    private var session: URLSession? = nil
    
    //是否拦截处理指定的请求
    override class func canInit(with request: URLRequest) -> Bool {
        let handleComponents = ["limitRequest"] // 要拦截的请求 - 自行修改
        if request.url?.scheme == "https" && handleComponents.contains(request.url?.lastPathComponent ?? "")  {
            // 处理过的
            if URLProtocol.property(forKey: forgeroundHandledKey, in: request) != nil || URLProtocol.property(forKey: backgroundHandledKey, in: request) != nil  {
                return false
            }
             return true
        }
       return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let cacheResponse = URLCache.shared.cachedResponse(for: self.request) {
            //有缓存先使用缓存
            //print(try! JSONSerialization.jsonObject(with: cacheResponse.data, options: JSONSerialization.ReadingOptions.allowFragments))
            client?.urlProtocol(self, didReceive: cacheResponse.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: cacheResponse.data)
            client?.urlProtocolDidFinishLoading(self)
            backgroundUpdate()
            return
        }
        //没有缓存
        URLProtocol.setProperty(true, forKey: forgeroundHandledKey, in: request as! NSMutableURLRequest)
        requset()
    }
    
    override func stopLoading() {
        session?.invalidateAndCancel()
        session = nil
    }
    
    func requset() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: forgeroundNetQueue)
        let task = session?.dataTask(with: self.request)
        task?.resume()
    }
    
    func backgroundUpdate() {
        backgroundNetQueue.addOperation { [weak self] in
            guard let self = self else { return }
            if let key = self.request.url?.absoluteString, let updateDate = HttpsURLProtocol.urlUpdateDic?[key] {
                //没到更新的时间就直接return
                if Date().timeIntervalSince(updateDate) < self.updateInterval { return }
            }
            //更新之前先设置标记
            URLProtocol.setProperty(true, forKey: backgroundHandledKey, in: self.request as! NSMutableURLRequest)
            self.requset()
        }
    }
    
    //MARK:- Delegation
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //请求到数据后，更新请求的时间
        HttpsURLProtocol.urlUpdateDic?[request.url?.absoluteString] = Date()
        
        //获取数据
        self.data = data
        self.client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
            //有数据就手动存储缓存
            guard let data = self.data, let response = task.response else { return }
            let cacheResponse = CachedURLResponse.init(response: response, data: data)
            URLCache.shared.storeCachedResponse(cacheResponse, for: request)
            self.data = nil
        }
    }
}
