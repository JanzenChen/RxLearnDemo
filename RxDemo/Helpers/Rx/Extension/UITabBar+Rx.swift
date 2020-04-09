//
//  UITabBar+Rx.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITabBar {
    var barTintColor: Binder<UIColor> {
        return Binder<UIColor>.init(base) { $0.barTintColor = $1 }
    }
}
