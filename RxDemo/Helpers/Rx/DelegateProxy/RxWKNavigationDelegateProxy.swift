//
//  RxWKNavigationDelegateProxy.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import WebKit
import RxSwift
import RxCocoa

class RxWKNavigationDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>, DelegateProxyType, WKNavigationDelegate {
    
    init(wkWebView: WKWebView) {
        super.init(parentObject: wkWebView, delegateProxy: RxWKNavigationDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register{ RxWKNavigationDelegateProxy(wkWebView: $0) }
    }
    
    static func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
        return object.navigationDelegate
    }
    
    static func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
        object.navigationDelegate = delegate
    }
}


extension Reactive where Base: WKWebView {
    
    var navigationDelegate: RxWKNavigationDelegateProxy {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }
    
    var navigationDidFinish: ControlEvent<()> {
        return ControlEvent(events: navigationDelegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didFinish:))).map{ _ in () })
    }
    ///手动设置ForwardDelegate
    func set(delegate: WKNavigationDelegate) -> Disposable {
        return RxWKNavigationDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
}
