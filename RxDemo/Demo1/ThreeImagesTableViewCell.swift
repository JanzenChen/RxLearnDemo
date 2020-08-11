//
//  ThreeImagesTableViewCell.swift
//  RxDemo
//
//  Created by Janzen on 2020/7/1.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import UIKit

class ThreeImagesTableViewCell: UITableViewCell {
    private let imageWidth = (UIScreen.main.bounds.size.width - 20.0 - 10.0) / 3.0
    
    private(set) var disposeBag : DisposeBag = DisposeBag()
    
    private lazy var firstImageView: UIImageView = createImgView(0)
    private lazy var secondImageView: UIImageView = createImgView(1)
    private lazy var thirdImageView: UIImageView = createImgView(2)
    
    open var imgTapSingal : PublishSubject<Int>?
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func legalUrlString(_ url: String) -> String {
        if url.hasPrefix("http:") {
            return url.replacingOccurrences(of: "http:", with: "https:")
        }
        return ""
    }
    
    private func createImgView(_ tapIndex: Int) -> UIImageView {
        let imgV = UIImageView(frame: .zero)
        imgV.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                if let imgTap = self.imgTapSingal {
                    print("---> onNext2 \(tapIndex)")
                    imgTap.onNext(tapIndex)
                }
        }.disposed(by: disposeBag)
        return imgV
    }
    
    func setup(_ news: NewsModel) {
        
        self.selectionStyle = .none
        
        let url = URL(string: legalUrlString(news.imgsrc))
        firstImageView.kf.setImage(with: url, placeholder:  UIImage(named: "placeholder"))
        
        if let imagesData = news.imgnewextra, imagesData.count == 2 {
            let images = imagesData.map { legalUrlString($0.imgsrc) }
            secondImageView.kf.setImage(with: URL(string: images[0]), placeholder:  UIImage(named: "placeholder"))
            thirdImageView.kf.setImage(with: URL(string: images[1]), placeholder:  UIImage(named: "placeholder"))
        }
        
        title.text = news.title
        source.text = news.source
    }
    
    private func setupUI() {
        contentView.addSubview(firstImageView)
        contentView.addSubview(secondImageView)
        contentView.addSubview(thirdImageView)
        contentView.addSubview(title)
        contentView.addSubview(source)
        
        title.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView).offset(10.0)
            make.trailing.equalTo(contentView).offset(-10.0)
        }
        
        firstImageView.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.top.equalTo(title.snp_bottomMargin).offset(15.0)
            make.width.equalTo(self.imageWidth)
            make.height.equalTo(80.0)
        }
        
        secondImageView.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(firstImageView)
            make.left.equalTo(firstImageView.snp_rightMargin).offset(10.0)
        }
        
        thirdImageView.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(secondImageView)
            make.left.equalTo(secondImageView.snp_rightMargin).offset(10.0)
        }
        
        source.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.bottom.equalTo(contentView).offset(-10.0)
            make.height.equalTo(15.0)
        }
    }

}
