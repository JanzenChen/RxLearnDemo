//
//  Bindable.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/7.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import Foundation
import RxSwift

protocol Bindable {
    var disposeBag: DisposeBag { get }
}


