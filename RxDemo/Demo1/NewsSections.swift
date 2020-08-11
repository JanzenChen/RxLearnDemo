//
//  NewsSections.swift
//  RxDemo
//
//  Created by Janzen on 2020/6/30.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

struct NewsSections {
    var header: String?
    var items: [NewsModel]
}

extension NewsSections: SectionModelType {
    typealias Item = NewsModel
    
    init(original: NewsSections, items: [Item]) {
        self = original
        self.items = items
    }
}
