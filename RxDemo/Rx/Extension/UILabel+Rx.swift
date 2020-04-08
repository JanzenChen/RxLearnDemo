//
//  UILabel+Rx.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/7.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        return Binder<UIColor>.init(base) { $0.textColor = $1 }
    }
}
