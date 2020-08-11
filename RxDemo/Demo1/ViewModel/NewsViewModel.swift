//
//  NewsViewModel.swift
//  RxDemo
//
//  Created by Janzen on 2020/6/30.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

class NewsViewModel: NSObject {
    
    private var offset = BehaviorRelay(value: "")
    private let disposed: DisposeBag = DisposeBag()
    
    // 懒加载实现一个信号观察者，相当于定义一个block，且声明这个block一定存在
    let imgTapSingal:PublishSubject<Int> = {
        return PublishSubject<Int>()
    }()
    
    // 实例化信号处理，相当于实现block的内容
    private let imgTapObserver : AnyObserver<Int> = AnyObserver { event in
        switch event {
            case .next(let data): print("next event --- \(data)")
            case .error(let error): print("error event --- \(error)")
            default:
                print("event ---\(event)")
                break
        }
    }
    
    override init() {
        // 信号监听，收到信号就执行block
        imgTapSingal.subscribe(imgTapObserver).disposed(by: disposed)
        
        super.init()
    }
    
    func transform(input: (BehaviorRelay<String>), dependecies: (NewsDataManager)) -> Driver<[NewsSections]> {
        offset = input
        return offset.asObservable()
            .throttle(DispatchTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(dependecies.getNews)
            .asDriver(onErrorJustReturn: [])
    }
}
