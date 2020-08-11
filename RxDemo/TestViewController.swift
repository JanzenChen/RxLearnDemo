//
//  TestViewController.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/7.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import UIKit

// MARK: @_silgen_name(2.2之前使用的是@asmname) 与 C代码的调用, 可不使用桥接文件直接映射c方法
@_silgen_name("test") func cfunc_test(a: Int32) -> Int32

class TestViewController: UIViewController, Bindable {
    
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        testSwift(input: 1)
    }
    
    func testSwift(input: Int32) {
        let res = cfunc_test(a: input)
        print(res)
    }
}
