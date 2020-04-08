//
//  MineSectionModel.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/28.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class MineSectionModel: NSObject {
    public var title : String?
    public var isShow : Bool = true
    
    init(SectionTitle title:String, isShow:Bool = true) {
        self.title = title
        self.isShow = isShow
    }
}

