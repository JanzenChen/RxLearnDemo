//
//  RegexHelper.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/21.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation
/// 使用方式
///   if "janzen@janzen.sina.cn" =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
///      print("有效的邮箱地址")
///  }
// MARK: 正则
fileprivate struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern:String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matchs = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matchs.count > 0
    }
}

precedencegroup RexgerPrecedence {
    associativity : none
    higherThan : DefaultPrecedence
}

infix operator =~ : RexgerPrecedence

public func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

