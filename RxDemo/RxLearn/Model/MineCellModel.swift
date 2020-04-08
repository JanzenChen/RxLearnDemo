//
//  MineCellModel.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/28.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class MineCellModel: NSObject {
    public var icon : String?
    public var name : String?
    public var detail : String?
    public var isSelected : Bool = false
    
    public init(userIcon icon : String, name:String, detail:String, isSelected:Bool = false) {
        self.icon = icon
        self.name = name
        self.detail = detail
        self.isSelected = isSelected
    }
}
