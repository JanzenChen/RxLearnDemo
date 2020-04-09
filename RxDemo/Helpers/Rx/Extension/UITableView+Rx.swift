//
//  UITableView+Rx.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var separatorColor: Binder<UIColor> {
        return Binder<UIColor>(base) { $0.separatorColor = $1 }
    }
}
