//
//  URL+Ex.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/9.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

extension URL {
    func append(prama: [String: Any]?) -> URL {
        guard let prama = prama else { return self }
        var count = 0
        var string = self.absoluteString
        for (key, value) in prama {
            guard let value = value as? String else { return self }
            let pramaString = "\(key)=\(value)"
            count == 0 ? string.append("?" + pramaString) : string.append("&" + pramaString)
            count += 1
        }
        return URL(string: string)!
    }
}
