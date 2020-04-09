//
//  Global.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

var mainWindow: UIWindow? {
    return UIApplication.shared.keyWindow
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    return result
}

func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}


var isIphoneX: Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
}
