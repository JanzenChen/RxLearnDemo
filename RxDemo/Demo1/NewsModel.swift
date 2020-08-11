//
//  NewsModel.swift
//  RxDemo
//
//  Created by Janzen on 2020/6/30.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation

struct NewsModel {
    var title: String
    var imgsrc: String
    var replyCount: String
    var source: String
    var imgnewextra: [Imgnewextra]?
}

struct Imgnewextra {
    var imgsrc: String
    
}
