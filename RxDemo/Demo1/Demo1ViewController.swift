//
//  Demo1ViewController.swift
//  RxDemo
//
//  Created by Janzen on 2020/6/30.
//  Copyright © 2020 JanzenMacmini. All rights reserved.
//

import UIKit

class Demo1ViewController: UIViewController {
    //UI
    private lazy var tableView: UITableView = {
        let tbView = UITableView(frame: self.view.bounds, style: .grouped)
//        tbView.scalesLargeContentImage
        
        tbView.backgroundColor = .white
        tbView.backgroundColor = UIColor.groupTableViewBackground
        tbView.rowHeight = UITableView.automaticDimension
        tbView.sectionHeaderHeight = 0.01//UITableView.automaticDimension -- 设置0是不可行的,还是默认
        tbView.sectionFooterHeight = 0.01//UITableView.automaticDimension -- 设置0是不可行的,还是默认
        tbView.separatorStyle = .none
        tbView.contentInset = UIEdgeInsets.zero
        tbView.contentInsetAdjustmentBehavior = .never
        return tbView
    }()
    
    private lazy var refreshItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Refresh", style: .done, target: nil, action: nil)
        item.tintColor = .red
        return item
    }()
    
    //ViewModel
    private let viewModel: NewsViewModel = NewsViewModel()
    
    //singal
    private let offset = BehaviorRelay(value: "0")
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<NewsSections>! = {
        return RxTableViewSectionedReloadDataSource<NewsSections>(configureCell: { dataSource, tableView, indexpath, item  in
            if item.imgnewextra?.isEmpty ?? true,
                let cell = tableView.dequeueReusableCell(withIdentifier: OneImageNewsTableViewCell.description(), for: indexpath) as? OneImageNewsTableViewCell {
                cell.setup(item)
                // 把cell的信号监听者设为viewModel的信号监听者,类似设置代理,或者说赋值block
                cell.imgTapSingal = self.viewModel.imgTapSingal
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: ThreeImagesTableViewCell.description(), for: indexpath) as? ThreeImagesTableViewCell {
                cell.setup(item)
                cell.imgTapSingal = self.viewModel.imgTapSingal
                return cell
            }
            return UITableViewCell()
        })
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = refreshItem
        
        setupTableView()
        bindSingal()
        
        view.updateConstraintsIfNeeded()
    }
    
    // 设置UI
    private func setupTableView() {
        tableView.register(OneImageNewsTableViewCell.self, forCellReuseIdentifier: OneImageNewsTableViewCell.description())
        tableView.register(ThreeImagesTableViewCell.self, forCellReuseIdentifier: ThreeImagesTableViewCell.description())
        
        view.addSubview(tableView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // 信号绑定
    private func bindSingal() {
        // 返回的事实上是offset的信号监听者
        let output = viewModel.transform(input: offset, dependecies: NewsDataManager.share)
        // 因为output被绑定到数据源,所以output是没有释放的,而output是监听的offset,只要offset一发信号,output就会执行监听到信号的处理
        output.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        refreshItem.rx.tap.bind {
            let offetV = Int(self.offset.value) ?? 0
            self.offset.accept("\(offetV + 10)")
        }.disposed(by: disposeBag)
        
    }

}

extension Demo1ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newSection = dataSource.sectionModels[indexPath.section]
        let news = newSection.items[indexPath.row]
        
        if news.imgnewextra?.isEmpty ?? true {
            return 100.0
        }
        return 180.0
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
//
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return nil
//    }
//
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

