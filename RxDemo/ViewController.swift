//
//  ViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/7/12.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var viewModel : ViewModel?
    
    func MaxA(a : String) -> Bool {
        return a > "3"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let textSign : BehaviorRelay<String> = BehaviorRelay(value: "Text")
        
        let lab = UILabel().then {
            $0.textColor = .red
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.sizeToFit()
            $0.layer.borderWidth = 2
        }
        
        let a1 : String? = "4"
        let a2 : Int = 5
        
        if let a = a1 , 4 != a2 {
            print("---> 111111 a == \(a)")
        }
        
        if let a = a1 , MaxA(a: a) {
            print("---> 222222")
        }
        
        
        
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.lessThanOrEqualToSuperview()
        }
        
        textSign.bind(to: lab.rx.text).disposed(by: disposeBag)
        //每个一秒发出一个索引  map ---bind  进行绑定
        let obserable1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        obserable1.map{"当前索引:\($0)"}.bind(to: textSign).disposed(by: disposeBag)

        let model = Model().then {
            $0.title = "title 1111"
            $0.name = "name 2222"
        }
        
        viewModel = ViewModel(model)
        viewModel?.titleObservable?.bind(to: lab.rx.text).disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            model.title = "title 222222"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let resNum = self.bigNumberSummation(number: "111111111111111111111111111111111111111111111111111111", num2: "1111111111111111111111111111111111111111111111111111111")
            model.title = resNum
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            let mod = Model().then {
                $0.title = "title 3333"
                $0.name = "name 3333"
            }
            self.viewModel?.updateModel(withModel: mod)
            self.text(number: 1111, count: 22222)
        }
        
        
        self.rx.methodInvoked(#selector(text(number:count:))).subscribe { (event) in
            print("\(String(describing: event.element?[0]))")
        }.disposed(by: disposeBag)
        
        applicationStateChangeObservable()
    
    }
    
    @objc dynamic func text(number num:Int, count:Int) {
        print("--->\(num) -- \(count)")
    }
    
    // 大数相加
    func bigNumberSummation(number num1:String, num2:String) -> String {
        // 输入的参数不是一个完全数字的字符串
        if !validateNumber(num1) || !validateNumber(num2) {
            assert(false, "Parameter input out of specification")
            return ""
        }
        
        // 反转Character数组
        var str1 : [Character] = num1.reversed()
        var str2 : [Character] = num2.reversed()
        
        // 缺位补0
        let maxLen = max(str1.count, str2.count)
        
        if str1.count != maxLen {
            for _ in (0 ..< maxLen - str1.count) {
                str1.append("0")
            }
        } else if str2.count != maxLen {
            for _ in (0 ..< maxLen - str2.count) {
                str2.append("0")
            }
        }
        
        // 各位相加逻辑
        var carryBit = 0;
        var sum : [Character] = [];
        for i in 0 ..< maxLen {
            let a = Int(String(str1[i]))!
            let b = Int(String(str2[i]))!
            
            var s = a + b + carryBit;
            if s >= 10 { // 进一位
                s -= 10
                carryBit = 1
            } else {
                carryBit = 0
            }
            sum.append(contentsOf: String(s)) // 记录当前位的结果
        }
        
        return String(sum.reversed()) // 重新反转回来
    }
    
    func validateNumber(_ str:String, scopeStr:String = "0123456789") -> Bool {
        let intSet = NSCharacterSet(charactersIn: scopeStr).inverted
        let filterStr = str.components(separatedBy: intSet).joined()
        return str == filterStr
    }
}


extension ViewController {
    func applicationStateChangeObservable() {
        //应用重新回到活动状态
        UIApplication.shared.rx
            .didBecomeActive
            .subscribe(onNext: { _ in
                print("应用进入活动状态。")
            })
            .disposed(by: disposeBag)
         
        //应用从活动状态进入非活动状态
        UIApplication.shared.rx
            .willResignActive
            .subscribe(onNext: { _ in
                print("应用从活动状态进入非活动状态。")
            })
            .disposed(by: disposeBag)
         
        //应用从后台恢复至前台（还不是活动状态）
        UIApplication.shared.rx
            .willEnterForeground
            .subscribe(onNext: { _ in
                print("应用从后台恢复至前台（还不是活动状态）。")
            })
            .disposed(by: disposeBag)
         
        //应用进入到后台
        UIApplication.shared.rx
            .didEnterBackground
            .subscribe(onNext: { _ in
                print("应用进入到后台。")
            })
            .disposed(by: disposeBag)
         
        //应用终止
        UIApplication.shared.rx
            .willTerminate
            .subscribe(onNext: { _ in
                print("应用终止。")
            })
            .disposed(by: disposeBag)
    }
}

class Model: NSObject {
    @objc dynamic var title : String? // 在swift中,想要使用KVO(rx.observe/rx.observeWeakly)必须使用@objc dynamic
    @objc dynamic var name : String?// 在swift中,想要使用KVO(rx.observe/rx.observeWeakly)必须使用@objc dynamic
}

class ViewModel: NSObject {
    @objc dynamic private var model : Model?
    
    public var titleObservable : Observable<String?>?
    public func updateModel(withModel model : Model) {
        self.model = model
    }
    
    required init(_ model : Model) {
        super.init()
        self.model = model
        self.bindSingal()
    }
    
    func bindSingal() {
        titleObservable = self.rx.observe(String.self, "model.title")
    }
}



