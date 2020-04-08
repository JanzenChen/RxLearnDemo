//
//  NavigationController.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/26.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 侧滑返回代理
        interactivePopGestureRecognizer?.delegate = self
        
        // 压栈出栈控制代理
        delegate = self
    }

//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVc : BaseViewController = topViewController as? BaseViewController else {
            return .lightContent
        }
        return topVc.preferredStatusBarStyle
    }
}

extension NavigationController : UIGestureRecognizerDelegate {
    
}

extension NavigationController : UINavigationControllerDelegate {
    
}
