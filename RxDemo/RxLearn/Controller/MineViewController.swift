//
//  MineViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/26.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {

    // 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: self.view.bounds, style: .grouped)
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight =  8.0
        tableView.register(MineSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MineSectionHeaderView.description())
        tableView.register(MineTableViewCell.self, forCellReuseIdentifier: MineTableViewCell.description())
        tableView.contentInset = self.navigationController?.view.safeAreaInsets ?? UIEdgeInsets.zero
        return tableView
    }()
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<MineSectionModel, MineCellModel>> = {
        var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<MineSectionModel, MineCellModel>>(configureCell: { (_, tableView, indexPath, model:MineCellModel) -> UITableViewCell in
            let cell : MineTableViewCell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCell.description())! as! MineTableViewCell
            
            cell.iconView.image = UIImage(named:model.icon ?? "");
            cell.nameLab.text = model.name ?? ""
            cell.detailLab.text = model.detail ?? ""
            cell.selectedIcon.image = UIImage(named:model.isSelected ? "icon_selected_H" : "icon_selected_N")
            
            return cell
        })
            
        return dataSource
    }()
    
    lazy var data : [SectionModel<MineSectionModel, MineCellModel>] = {
        var section_1 = MineSectionModel(SectionTitle: "第一组", isShow: true)
        var sectionItem_1 = SectionModel(model: section_1, items: [model_1])
        
        var section_2 = MineSectionModel(SectionTitle: "第二组", isShow: true)
        var sectionItem_2 = SectionModel(model: section_2, items: [model_2_1,model_2_2,model_2_3])
        
        var section_3 = MineSectionModel(SectionTitle: "第三组", isShow: true)
        var sectionItem_3 = SectionModel(model: section_3, items: [model_3_1,model_3_2])
        
        var section_4 = MineSectionModel(SectionTitle: "第四组", isShow: true)
        var sectionItem_4 = SectionModel(model: section_4, items: [model_4_1,model_4_2])
        
        return Array(arrayLiteral: sectionItem_1,sectionItem_2,sectionItem_3,sectionItem_4)
    }()
    
    let model_1 = MineCellModel(userIcon: "icon_1", name: "巴拉巴拉", detail: "大师大师兄在擦拭离开按时打算明年时空裂缝考虑是哪里哪里苏打水老大")
    
    let model_2_1 = MineCellModel(userIcon: "icon_2", name: "大师傅", detail: "副董事长ad")
    let model_2_2 = MineCellModel(userIcon: "icon_3", name: "爱仕达(∩_∩)", detail: "哦哦好本基金开始开机卡即可")
    let model_2_3 = MineCellModel(userIcon: "icon_4", name: "🇨🇼圣诞快乐", detail: "的借口啦看咯帕斯卡拉那不卡刷卡了吗2看了吗收到了拿到卡里面呢2")
    
    let model_3_1 = MineCellModel(userIcon: "icon_5", name: "金坷垃金坷垃", detail: "房地产史蒂夫的sss辅导员")
    let model_3_2 = MineCellModel(userIcon: "icon_6", name: "加里奥的婚纱店", detail: "考虑尽快离开蓝可乐你考虑考虑马卡龙骂死的奥术大师大所大所大所大所大所大所多")
    
    let model_4_1 = MineCellModel(userIcon: "icon_7", name: "半开门学校", detail: "你那么较好的超炫山地车")
    let model_4_2 = MineCellModel(userIcon: "icon_8", name: "加里奥的婚纱店", detail: "爱谁谁三生三世十里桃花")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的"
        
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        
        viewlayout()
        
        let items = Observable.just(data)
        
        //binging
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, self.dataSource[indexPath])
            }
            .subscribe(onNext: { pair in
                let model : MineCellModel = pair.1
                print("\(model.name ?? "") -- \(model.detail ?? "")")
//                print("Tapped `\(pair.1)` @ \(pair.0)")
                model.isSelected = !model.isSelected
                self.tableView.reloadRows(at: [pair.0], with: .none)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

//MARK: function
    fileprivate func viewlayout () {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


extension MineViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : MineSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MineSectionHeaderView.description()) as! MineSectionHeaderView
        
        let sectionModel = data[section]
        let sectionItem : MineSectionModel =  sectionModel.model
        
        headerView.titleLab.text = sectionItem.title
        headerView.showSwich.isOn = sectionItem.isShow
        
        headerView.showSwich.rx.isOn.asObservable().distinctUntilChanged().subscribe(onNext: { (isOn) in
            sectionModel.model.isShow = isOn;
        }).disposed(by: headerView.disposeBag)
        
        return headerView
    }
}
