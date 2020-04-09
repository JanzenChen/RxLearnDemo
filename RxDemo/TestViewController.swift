//
//  TestViewController.swift
//  RxDemo
//
//  Created by Janzen on 2020/4/7.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, Bindable {

    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UILabel()
        tableView.rx.textColor
    }

}
