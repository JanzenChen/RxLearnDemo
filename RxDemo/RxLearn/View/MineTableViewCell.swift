//
//  MineTableViewCell.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/28.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    let iconView = UIImageView()
    let nameLab = UILabel()
    let detailLab = UILabel()
    let selectedIcon = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        iconView.layer.cornerRadius = 15;
        iconView.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMaxXMinYCorner.rawValue | CACornerMask.layerMaxXMaxYCorner.rawValue)
        iconView.layer.masksToBounds = true
        contentView.addSubview(iconView)
        
        nameLab.font = UIFont.systemFont(ofSize: 14)
        nameLab.textColor = UIColor.black
        nameLab.textAlignment = .left
        contentView.addSubview(nameLab)
        
        detailLab.font = UIFont.systemFont(ofSize: 10)
        detailLab.textColor = UIColor.gray
        detailLab.textAlignment = .left
        detailLab.numberOfLines = 0
        contentView.addSubview(detailLab)
        
        contentView.addSubview(selectedIcon)
        
        // layout
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-20).priorityLow()
            make.width.height.equalTo(60)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(5)
            make.bottom.equalTo(iconView.snp_centerY).offset(-2)
            make.right.lessThanOrEqualToSuperview().offset(-150)
        }
        
        detailLab.snp_makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.lessThanOrEqualToSuperview().offset(-60)
            make.top.equalTo(nameLab.snp_bottom).offset(5)
        }
        
//        detailLab.snp.makeConstraints { (make) in
//            make.left.equalTo(nameLab)
//            make.right.lessThanOrEqualToSuperview().offset(-60)
//            make.top.equalTo(nameLab.snp_bottom).offset(5)
//        }
        
        selectedIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(22)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
