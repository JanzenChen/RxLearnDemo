//
//  OneImageNewsTableViewCell.swift
//  RxDemo
//
//  Created by Janzen on 2020/7/1.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import UIKit

class OneImageNewsTableViewCell: UITableViewCell {
    private(set) var disposeBag : DisposeBag = DisposeBag()
    // 在视图中创建信号观察者，留给外部赋值，相当于oc中的block变量
    open var imgTapSingal : PublishSubject<Int>?
    
    private lazy var newsImageView: UIImageView = {
        let imgV = UIImageView(frame: .zero)
        // 图片点击事件
        imgV.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                // 如果有这个信号观察者，用这个信号观察者发送一个信号，相当于！block?block(0)
                if let imgTap = self.imgTapSingal {
                    print("---> onNext \(0)")
                    imgTap.onNext(0)
                }
        }.disposed(by: disposeBag)
        return imgV
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.numberOfLines = 2
        return label
    }()

    private lazy var source: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .gray
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open func setup(_ news: NewsModel) {
        
        self.selectionStyle = .none
        
        var imgsrc = ""
        if news.imgsrc.hasPrefix("http:") {
            imgsrc = news.imgsrc.replacingOccurrences(of: "http:", with: "https:")
        }
        let url = URL(string: imgsrc)
        newsImageView.kf.setImage(with: url, placeholder:  UIImage(named: "placeholder"))
        title.text = news.title
        source.text = news.source
    }
    
    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(title)
        contentView.addSubview(source)
        
        newsImageView.snp.makeConstraints { make in
            make.width.equalTo(120.0)
            make.height.equalTo(80.0)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-10.0)
        }
        
        title.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).offset(10.0)
            make.trailing.equalTo(newsImageView.snp_leadingMargin).offset(-10.0)
        }
        
        source.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.bottom.equalTo(contentView).offset(-10.0)
            make.height.equalTo(15.0)
        }
    }
}
