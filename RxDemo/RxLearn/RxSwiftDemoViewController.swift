//
//  RxSwiftDemoViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/11/21.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

enum DBError: Error {
    case OnErrorEvent
}

typealias Rx = RxSwiftDemoViewController

class RxSwiftDemoViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red;
        
//        self.observableNormalCreate()
//        self.observablesSingleCreate()
//        self.observablesCompletableCreate()
//        self.observablesMaybeCreate()
//        self.observablesDriverCreate()
//        self.observablesSignalCreate()
        
//        self.anyObserverCreate()
//        self.asyncSubjectCreate()
//        self.publishSubjectCreate()
//        self.replaySubjectCreate()
//        self.behaviorSubjectCreate()
        
//        self.bufferTransformUseing()
//        self.windowTransformUseing()
//        self.mapTransformUseing()
//        self.flatMapTransformUseing()
//        self.scanTransformUseing()
//        self.groupByTransformUseing()
        
//        self.filterOperatorUseing()
//        self.sampleOperatorUseing()
//        self.debounceOperatorUseing()
        
//        self.ambOperatorUseing()
//        self.takeWhileOperatorUseing()
//        self.takeUntilOperatorUseing()
//        self.takeUntilOperatorUseing2()
//        self.skipWhileOperatorUseing()
//        self.skipWhileOperatorUseing2()
        
//        self.startWithOperatorUseing()
//        self.mergeOperatorUseing()
//        self.zipOperatorUseing()
//        self.combineLatestOperatorUseing()
//        self.withLatestFromOperatorUseing()
//        self.switchLatestOperatorUseing()
        
//        self.toArrayOperatorUseing()
//        self.reduceOperatorUseing()
        self.concatOperatorUseing()
    }
}

//MARK: - 可监听序列信号创建
extension Rx {
    //MARK: 普通信号创建
    func observableNormalCreate() {
        let datas : Observable<Int> = Observable.create { observable -> Disposable in
            
            observable.onNext(1)
            observable.onNext(2)
            observable.onNext(3)
            observable.onNext(4)
            observable.onNext(5)
            observable.onNext(6)
            observable.onCompleted() // 走了onCompleted或者走了onError都会直接结束,不会继续走后面的代码
//            observable.onError(DBError.OnErrorEvent)
            
            return Disposables.create()
        }
        
        _ = datas.subscribe { event in
            print("\(event) -- value= \(String(describing: event.element))")
        }
    }
    
    //MARK: Single信号创建
    func observablesSingleCreate() {
        func createSingle(_ res:Bool) -> Single<Int> {
            // Single 发出一个元素，或一个 error 事件 , 发送一次就停止, 二选一
            return Single<Int>.create { (single:@escaping (SingleEvent<Int>) -> Void) -> Disposable in
                if res == true {
                    single(.success(1))
//                    single(.success(1)) // 不管发送多少次,发送一次就停止
                } else {
                    single(.error(DBError.OnErrorEvent))
                }
                return Disposables.create()
            }
        }
        
        let datas = createSingle(true) // true or false
        _ = datas.subscribe(onSuccess: { num in print("\(num)") }, onError: { error in print("\(error)")})
    }
    
    //MARK: Completable信号创建
    func observablesCompletableCreate() {
        func createCompletable(_ res:Bool) -> Completable {
            // Completable 不会发出任何元素 ; 只会发出一个 completed 事件或者一个 error 事件 , 二选一
            return Completable.create { (completeable : @escaping (CompletableEvent) -> Void) -> Disposable in
                if res == true {
                    completeable(.completed)
                } else {
                    completeable(.error(DBError.OnErrorEvent))
                }
                return Disposables.create()
            }
        }
        //
//        let datas = createCompletable(true) // true or false
//        _ = datas.subscribe({ (event : CompletableEvent) in print("\(event)");})
        _ = createCompletable(true).subscribe({ (event : CompletableEvent) in print("\(event)");})
    }
    
    //MARK: Maybe信号创建
    func observablesMaybeCreate() {
        func createMaybe(_ res:Int) -> Maybe<String> {
            // Maybe 发出一个元素、或者一个 completed 事件、或者一个 error 事件 三个只会走一个
            return Maybe.create { (maybe:@escaping (MaybeEvent<String>) -> Void) -> Disposable in
                switch res {
                case 0: maybe(.success("Maybe Success"))
                case 1: maybe(.completed)
                default: maybe(.error(DBError.OnErrorEvent))
                }
                return Disposables.create()
            }
        }
        // -1 0 1
        _ = createMaybe(0).subscribe({ (event:MaybeEvent<String>) in print("\(event)");})
    }
    
    //MARK: Driver信号创建
    func observablesDriverCreate() {
        
        let datas = BehaviorSubject(value: "Driver--000")
        
        let lab = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 30));
        lab.textColor = .black
        self.view.addSubview(lab)
        
        _ = datas.asDriver(onErrorJustReturn: "title -> Empty1").map({ (str) -> String in
            print("--- str1 = \(str)")
            return str
        }).drive(self.rx.title).disposed(by: disposeBag)
        
        // drive 会给新的订阅者回溯上一个消息
        // drive 在 onCompleted 与 onError 出发一个后就不会走
        datas.onNext("Driver--111") // 立即发送信号 -> 已经发送完毕,但后续的订阅者依然能收到该消息,关键在于BehaviorSubject
//        datas.onError(DBError.OnErrorEvent) // 错误信号,两个地方都会收到
        
        _ = datas.asDriver(onErrorJustReturn: "title -> Empty2").map({ (str) -> String in
            print("--- str2 = \(str)")
            return str
        }).drive(lab.rx.text).disposed(by: disposeBag)
    }
    
    //MARK: Signal信号创建
    func observablesSignalCreate() {
        let datas = BehaviorSubject(value: "Driver--000")
        
        let lab = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 30));
        lab.textColor = .black
        self.view.addSubview(lab)
        
        _ = datas.asSignal(onErrorJustReturn: "title -> Empty1").map({ (str) -> String in
            print("--- str = \(str)")
            return str
        }).emit(to: self.rx.title).disposed(by: disposeBag)
        
        // Signal 会给新的订阅者回溯上一个消息
        // Signal 在 onCompleted 与 onError 出发一个后续的就不会走
          datas.onNext("1111") // 立即发送信号 -> 已经发送完毕,但后续的订阅者依然能收到该消息,关键在BehaviorSubject(value: "Driver--000")
//        datas.onError(DBError.OnErrorEvent) // 错误信号,两个地方都会收到
        
        _ = datas.asSignal(onErrorJustReturn: "title -> Empty2").map({ (str) -> String in
            print("--- str = \(str)")
            return str
        }).emit(to:lab.rx.text).disposed(by: disposeBag)
    }
}

//MARK: - 观察者创建
extension Rx {
    //MARK: AnyObserver观察者创建
    func anyObserverCreate() {
        let observer : AnyObserver<Any> = AnyObserver { event in
            switch event {
                case .next(let data): print("next event --- \(data)")
                case .error(let error): print("error event --- \(error)")
                default:
                    print("event ---\(event)")
                    break
            }
        }
        
        let subject = PublishSubject<Any>()
//        subject.bind(to: observer).disposed(by: self.disposeBag)
        subject.subscribe(observer).disposed(by: self.disposeBag)
        subject.onNext("1")
        subject.onNext(2)
        subject.onError(DBError.OnErrorEvent) // 收到error或completedx信号后就不会继续
        subject.onCompleted()
    }
    
    //MARK: AsyncSubject创建
    func asyncSubjectCreate() {
        let subject = AsyncSubject<Any>()
        subject.subscribe {print("--- AsyncSubject event = \($0)")}.disposed(by: self.disposeBag)
        subject.onNext("1") // 不是最后一个,不会发出
        subject.onNext(2) // 是最后一个,收到onCompleted后才会发出,否则不发出,收到的error也不会发出 AsyncSubject只在收到onCompleted才发出最后一个
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            subject.onError(DBError.OnErrorEvent) // 收到error或completedx信号后就不会继续
            subject.onCompleted()
        }
    }
    
    //MARK: AsyncSubject创建
    func publishSubjectCreate() {
        let subject = PublishSubject<String>()
        // 第一个监听者
        subject.subscribe {print("Subscription: 1 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱") // 第二个监听者前发送,第二个监听者不会收到信号
        // 第二个监听者
        subject.subscribe {print("Subscription: 2 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🅰️")
        subject.onNext("🅱️")
    }
    
    //MARK: ReplaySubject创建
    func replaySubjectCreate() {
        //ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的
        let subject = ReplaySubject<String>.create(bufferSize: 5) // bufferSize最多重复之前的多少个信号
        // 第一个监听者
        subject.subscribe {print("Subscription: 1 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱")
        subject.onNext("🐷")
        subject.onNext("🐔")
        // 第二个监听者
        subject.subscribe {print("Subscription: 2 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🅰️")
        subject.onNext("🅱️")
    }
    
    //MARK: ReplaySubject创建
    func behaviorSubjectCreate() {
        //当观察者对 BehaviorSubject 进行订阅时，它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
        let subject = BehaviorSubject(value: "🔴") // 默认元素
        //第一个订阅者
        subject.subscribe {print("Subscription: 1 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱") // 第二个订阅者订阅前的最新一个元素,所以第二个订阅者也能收到
        subject.debug().subscribe {print("Subscription: 2 Event:", $0)}.disposed(by: disposeBag)
        //第二个订阅者
        subject.onNext("🅰️")
        subject.onNext("🅱️") // 第三个订阅者订阅前的最新一个元素,所以第三个订阅者也能收到
        //第三个订阅者
        subject.subscribe {print("Subscription: 3 Event:", $0)}.disposed(by: disposeBag)
        subject.onNext("🍐")
        subject.onNext("🍊")
    }
}

//MARK:- 变换操作符号(Transforming Observables) 的使用
extension Rx {
    //MARK: buffer的使用
    func bufferTransformUseing() {
        let subject = PublishSubject<String>()
        //每缓存3个元素则组合起来一起发出。
        //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
        subject
            .buffer(timeSpan: DispatchTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { print(3 == $0.count ? "又满一箩筐:" : "没满一箩筐:",$0) })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onNext("3")
        subject.onCompleted()
    }
    
    //MARK: window的使用
    func windowTransformUseing() {
        let subject = PublishSubject<String>()
        //每1秒发出一次信号,有元素立刻发信号,够count个就合并三个一起发,不够count个也发
        //如果1秒钟内不够3个也会发出）
        subject
            .window(timeSpan: DispatchTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                guard let `self` = self else {return}
                print("subscribe: \($0)")
                $0.asObservable()
                    .subscribe(onNext: { print($0) })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onNext("4")
        subject.onNext("5")
    }
    
    //MARK: map的使用
    func mapTransformUseing() {
        Observable<Int>.of(1,2,3,4,5,6,7,8,9,10)
            .map{$0*$0}
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
    }
    
    //MARK: flatMap 与 flatMapLatest 与 concatMap 的使用
    func flatMapTransformUseing() {
        // flatMap 与 flatMapLatest 与 concatMap可以将信号中包含的信号解析出来,起到降维的作用
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let subject3 = BehaviorSubject(value: "①")
         // BehaviorRelay和BehaviorSubject差不多，但是收到error or completed后依然继续
        let subjectTotal = BehaviorRelay(value: subject1)
         
        subjectTotal.asObservable()
//            .flatMap { $0 } // 这里的$0 是subject1与subject2 , flatMap会对曾经的所有内部信号做缓存,变更只会新增,不会丢弃
//            .flatMapLatest { $0 } // flatMapLatest只会对当前的内部监听,以前的信号不会再做监听
            .concatMap { $0 } //concatMap 效果与flatMap一样,会对曾经的所有内部信号做缓存,但只会缓存最新的一个信号值,区别在于有先后顺序,先进的信号全部完成(即发送了onCompleted事件后)才会监听下一个的信号, 类似GDC的线程组
            .subscribe(onNext: { print($0) }) //flatMap返回的是subjectTotal的value,即subject1与subject2,对他们做信号监听拿到的是subject1与subject2发出的信号
            .disposed(by: disposeBag)
         
        subject1.onNext("B")
        subjectTotal.accept(subject2) // 改变subjectTotal内部的信号可监听序列,flatMap依然会对subject1最监听,flatMapLatest不会
        subject2.onNext("2")
        subject1.onNext("C")
        subjectTotal.accept(subject3) // 改变subjectTotal内部的信号可监听序列,flatMap依然会对subject1,subject2最监听,flatMapLatest不会
        subject3.onNext("②")
        subject3.onNext("③") //concatMap在subject2.onCompleted()后只会接收subject3发送的最新值③,之前的丢弃
        subject2.onNext("3")//concatMap在subject1.onCompleted()后只会接收subject2发送的最新值3,之前的丢弃
        subject1.onNext("D")
        subject1.onCompleted()
        subject2.onCompleted()
        subject3.onCompleted()
        
    }
    
    //MARK: Scan的使用
    func scanTransformUseing() {
        // scan 将信号的值与 初始累加器值 做第二个参数所设定的处理,scan的第一个参数为 初始累加器值
        Observable<Int>.range(start: 1, count: 5)
            .scan(100) { $0 + $1 } // 闭包的第一个参数为 初始累加器值, 第二个参数才是 当前信号的值
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
    }
    
    //MARK: groupBy的使用
    func groupByTransformUseing() {
        // groupBy 将一组信号分组为几个组
        Observable<Int>.range(start: 1, count: 20)
            .groupBy { 0 == $0 % 2 ? "偶数" : "奇数" }
            .subscribe { (event:Event<GroupedObservable<String, Int>>) in
                print("--------- 收到一组分组后的信号 : ", event)
                // 解析分组信号中的信号
//                _ = event.element?.asObservable().subscribe({ (event:Event<Int>) in
//                    print(event)
//                }).disposed(by: self.disposeBag)
        }.disposed(by: self.disposeBag)
    }
}

//MARK:- 过滤操作符(Filtering Observables) 的使用
extension Rx {
    //MARK: 常见过滤操作符
    func filterOperatorUseing() {
        // 常见过滤操作符
        Observable.of(2, 12, 5, 5, 28, 55, 10, 30, 10, 28, 28, 28, 28, 55, 30)
            .skip(2) //跳过前2个信号 与 take 相反 ->[5, 5, 28, 55, 10, 30, 10, 28, 28, 28, 28, 55, 30]
            .filter { $0 > 15 } // 过滤小于15的值 [28, 55, 30, 28, 28, 28, 28, 55, 30]
            .distinctUntilChanged() // 过滤掉连续重复的事件 -> [28, 55, 30, 28, 55, 30]
            .take(4) // 只取前4个信号, 之后的所有信号丢弃 与 skip 相反 -> [28, 55, 30, 28]
            .takeLast(3) // 只取最后3个信号,之后的所有信号丢弃, take 的倒序 -> [55, 30, 28]
//            .single { $0 == 30 } // 返回一个bool值,即只发送 等于 30 的值 且 只发送一次, 即变成single可监听序列信号
            .elementAt(0) // 0 1 2 3 ... 取信号数组中的第一个元素
//            .ignoreElements() // 忽略所有元素
            .subscribe { print($0) }
            .disposed(by: self.disposeBag)
    }
    
    //MARK: sample过滤操作符
    func sampleOperatorUseing() {
        // Sample 除了订阅源Observable 外，还可以监视另外一个 Observable， 即 notifier 。
        // 每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
         
        source
            .sample(notifier) //source的next时间依赖于notifier,notifier发送一次信号后,source发送最新的信号一次
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext(1)
         
        //让源序列接收接收消息
        notifier.onNext("A") // notifier发送一次信号,source当前最新的信号为1,所以source发送1
         
        source.onNext(2)
         
        //让源序列接收接收消息
        notifier.onNext("B") // notifier发送一次信号,source当前最新的信号为2,所以source发送2
        notifier.onNext("C") // 两次 notifier 事件之间没有源序列的事件，source不发送值。
         
        source.onNext(3)
        source.onNext(4)
         
        //让源序列接收接收消息
        notifier.onNext("D") // notifier发送一次信号,source当前最新的信号为4,所以source发送4
         
        source.onNext(5)
         
        //让源序列接收接收消息
        notifier.onCompleted() // notifier发送一次信号,source当前最新的信号为5,所以source发送5
    }
    
    //MARK: debounce过滤操作符
    func debounceOperatorUseing() {
        // debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
        // 换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
        // debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
        
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]
        
        //生成对应的 Observable 序列并订阅
        Observable.from(times)
            .flatMap({ (item:[String : Double]) -> Observable<Int> in
                return Observable.of(Int(item["value"]!)).delaySubscription(DispatchTimeInterval.milliseconds(Int(Double(item["time"]!) * 100)), scheduler: MainScheduler.instance)
            })
            .debounce(DispatchTimeInterval.milliseconds(50), scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
    }
}

//MARK:- 条件和布尔操作符（Conditional and Boolean Operators）的使用
extension Rx {
    //MARK: amb的使用
    func ambOperatorUseing() {
        //amb 当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
         
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
         
        subject1.onNext(10) //subject1 subject2 subject3 三个关联,取三个中第一个发消息的可监听序列,即,当前如果第一个发信号的是subject1,那么后续只会发出subject1的信号,其他的信号再怎么嚷嚷也不管
        subject3.onNext(0)
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(1)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(2)
        subject3.onNext(3)
    }
    
    //MARK: amb的使用
    func takeWhileOperatorUseing() {
        // 该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
        Observable.range(start: 1, count: 100)
//            .takeWhile { !(0 == $0 % 3) } // 当第一个不满足条件的值出现时，它便自动完成。
            .takeUntil(.inclusive ) { $0 > 5 } // .inclusive .exclusive
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
    }
    //MARK: takeUntil的使用
    func takeUntilOperatorUseing() {
        // 该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
        Observable.range(start: 1, count: 100)
//            .takeWhile { !(0 == $0 % 3) } // 当第一个不满足条件的值出现时，它便自动完成。
            .takeUntil(.inclusive ) { $0 > 5 } // .inclusive .exclusive -> .inclusive  包含当前判断的信号,即 6 > 5,但是依然发出6,下一个信号不再发出; .exclusive 6 > 5, 6不再发出
            .subscribe(onNext: { print($0) })
            .disposed(by: self.disposeBag)
    }
    //MARK:- takeUntil的使用
    func takeUntilOperatorUseing2() {
        // 除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
        // 如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
         
        source
            .takeUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
         
        //停止接收消息
        notifier.onNext("z")
         
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }
    //MARK:- skipWhile的使用
    func skipWhileOperatorUseing() {
        //该方法用于跳过前面所有满足条件的事件。一旦遇到不满足条件的事件，之后就不会再跳过了。
        Observable.of(2, 3, 4, 5, 6)
            .skipWhile { $0 < 4 } // 过滤掉 遇到大于4的信号前 的所有信号
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //MARK:- skipWhile的使用
    func skipWhileOperatorUseing2() {
        //该方法用于跳过前面所有满足条件的事件。一旦遇到不满足条件的事件，之后就不会再跳过了。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
         
        source
            .skipUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
         
        //开始接收消息 -- source跳过notifier信号发出前的所有信号
        notifier.onNext(0)
         
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
         
        //仍然接收消息
        notifier.onNext(0)
         
        source.onNext(9)
    }
    
}

//MARK:- 组合操作符(Combining Observables) 的使用
extension Rx {
    //MARK:startWith的使用
    func startWithOperatorUseing() {
        //startWith 在序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息(只能是onNext信号)。
        // 可以插入多个,类似于 Array.inserAtIndex(0)
        let disposeBag = DisposeBag()
         
        Observable.of("2", "3")
            .startWith("a")
            .startWith("b")
            .startWith("c")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //MARK: merge的使用
    func mergeOperatorUseing() {
        //merge 可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable序列,每个序列发送的信号(只能是onNext信号)都将出发该信号
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
         
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
//        subject2.onCompleted() // 只能是onNext信号
    }
    
    //MARK: zip的使用
    func zipOperatorUseing() {
        // zip可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。 而且它会等到每个 Observable 事件(只能是onNext信号)一一对应地凑齐之后再合并, 否则不合并。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
         
        Observable.zip(subject1, subject2) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
 
    //MARK: combineLatest的使用
    func combineLatestOperatorUseing() {
        // combineLatest 将多个（两个或两个以上的）Observable 序列元素进行合并。每当任意一个 Observable 有新的事件(OnNext事件)发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
         
        Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
    //MARK: withLatestFrom的使用
    func withLatestFromOperatorUseing() {
        //withLatestFrom 将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
         
        subject1.withLatestFrom(subject2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("A") // 所依赖的subject2没有值,不发送
        subject2.onNext("1")
        subject1.onNext("B") // 所依赖的subject2当前最新值为1,发送1
        subject1.onNext("C") // 所依赖的subject2当前最新值为1,发送1
        subject2.onNext("2")
        subject1.onNext("D") // 所依赖的subject2当前最新值为2,发送2
    }
    
    //MARK: withLatestFrom的使用
    func switchLatestOperatorUseing() {
        // switchLatest 可以对事件流进行转换。比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2。
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let subjectTotal = BehaviorRelay(value: subject1)
         
        subjectTotal.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("A")
        subject1.onNext("B")
         
        subject1.onNext("C")
        //改变事件源
        subjectTotal.accept(subject2)
        subject1.onNext("D")
        subject1.onNext("E")
        subject1.onNext("F")
        subject2.onNext("1")
        subject2.onNext("2")
         
        //改变事件源
        subjectTotal.accept(subject1)
        subject2.onNext("3")
        subject1.onNext("G")
    }
    
}
//MARK:- 算数、以及聚合操作符(Mathematical and Aggregate Operators) 的使用
extension Rx {
    //MARK: toArray的使用
    func toArrayOperatorUseing() {
        // toArray 先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束。
        Observable.of(1, 2, 3, 4, 5)
            .toArray() // toArray 返回的是一个Single信号,只会发送一次就结束,不是success就是error
            .subscribe(onSuccess: { print($0) }, onError: {print($0)})
            .disposed(by: self.disposeBag)
    }
    
    //MARK: reduce的使用
    func reduceOperatorUseing() {
        // reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去。
        Observable.of(1, 2, 3, 4, 5)
            .reduce(100, accumulator: +, mapResult: { $0 % 25 })
            .subscribe(onNext: {print($0)})
            .disposed(by: self.disposeBag)
    }
    
    //MARK: concat的使用
    func concatOperatorUseing() {
        // concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。且只有当前一个 Observable序列发出了 completed 事件后，才会开始发送下一个 Observable 序列事件。
        let subject1 = ReplaySubject<Any>.create(bufferSize: 10)//PublishSubject<Any>()//BehaviorSubject(value: 1)
        let subject2 = ReplaySubject<Any>.create(bufferSize: 10)//PublishSubject<Any>()//BehaviorSubject(value: 11)
        
        let variable = BehaviorRelay(value: subject1)
        variable.asObservable()
            .concat()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject2.onNext(22)
        subject2.onNext(22)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.accept(subject2) // subject的类型为BehaviorSubject,所以只发送信号最新值; subject的类型为PublishSubject,不缓存值;ReplaySubject重复前面的值
        subject2.onNext(33)
        subject2.onNext(33)
    }
}


/*
 
 下标脚本语法及应用
 
 语法
 
 下标脚本允许你通过在实例后面的方括号中传入一个或者多个的索引值来对实例进行访问和赋值。
 语法类似于实例方法和计算型属性的混合。
 与定义实例方法类似，定义下标脚本使用subscript关键字，显式声明入参（一个或多个）和返回类型。
 与实例方法不同的是下标脚本可以设定为读写或只读。这种方式又有点像计算型属性的getter和setter：
 
 */
class Daysofaweek {
    private var days = ["Sunday", "Monday", "Tuesday", "Wednesday",
                        "Thursday", "Friday", "saturday"]
    // 类方法
    class func testSubscript() {
        let p = Daysofaweek()
        
        p[2] = "my brithday"
        
        print(p[0])
        print(p[1])
        print(p[2])
        print(p[3])
    }
    
    subscript(index: Int) -> String {
        get {
            return days[index]   // 声明下标脚本的值
        }
        set(newValue) {
            self.days[index] = newValue   // 执行赋值操作
        }
    }
}
