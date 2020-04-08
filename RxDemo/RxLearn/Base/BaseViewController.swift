//
//  BaseViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/26.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        guard navigationController?.topViewController == self else { // 当前控制器不在栈顶,丢弃
            return;
        }
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
