//
//  MineSectionHeaderView.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/28.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class MineSectionHeaderView: UITableViewHeaderFooterView {

    let titleLab = UILabel()
    let showSwich = UISwitch()
    var disposeBag = DisposeBag()
    
    //每次重用cell的时候都会释放之前的disposeBag，为cell创建一个新的dispose。保证cell被重用的时候不会被多次订阅，造成错误
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .left
        contentView.addSubview(titleLab)
        
        showSwich.isOn = false
        showSwich.tintColor = UIColor.blue
        showSwich.thumbTintColor = UIColor.red
        contentView.addSubview(showSwich)
        
        titleLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -80))
        }
        
        showSwich.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp_right).offset(-10)
            make.top.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
