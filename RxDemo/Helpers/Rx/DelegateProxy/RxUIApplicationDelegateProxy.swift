//
//  RxUIApplicationDelegateProxy.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/7.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
 
//UIApplicationDelegate 代理委托
public class RxUIApplicationDelegateProxy : DelegateProxy<UIApplication, UIApplicationDelegate>, UIApplicationDelegate, DelegateProxyType {
     
    public weak private(set) var application: UIApplication?
     
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }
     
    public static func registerKnownImplementations() {
        self.register { RxUIApplicationDelegateProxy(application: $0) }
    }
     
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
     
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
        object.delegate = delegate
    }
     
    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
}
