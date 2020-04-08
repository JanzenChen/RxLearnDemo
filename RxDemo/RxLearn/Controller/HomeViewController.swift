//
//  HomeViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/26.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    lazy var tableView : UITableView = {
        var tableView = UITableView(frame: view.bounds, style: .plain)
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCellID")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的"
        
        tableViewLayout()
        
        let items : Observable = Observable.just(
            (0..<20).map({ (num) -> String in
                if (0 == num) {
                    return "User Login"
                }
                return "\(num)"
            })
        )
        
//        简写 尾随闭包/省参/省返回/去return
//        let items = Observable.just((0..<20).map{"\($0)"})
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "HomeCellID", cellType: UITableViewCell.self), curriedArgument:{(row,element,cell) in
                cell.selectionStyle = .none
                cell.textLabel?.text = "\(element) @ row \(row)"
            })
            .disposed(by: disposeBag)
//        简写 尾随闭包 详查bind方法中的R1
//        items
//            .bind(to: tableView.rx.items(cellIdentifier: "HomeCellID", cellType: UITableViewCell.self)) { (row,element,cell) in
//                cell.textLabel?.text = "\(element) @ row \(row)"
//            }
//            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { (cellData) in
                print("点击了\(cellData)")
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map {indexPath -> String in
                   return "点击了第\(indexPath.row)个Cell"
                }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
        
    }
    
    //MARK: - function
    fileprivate func tableViewLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }


}
