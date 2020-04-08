//
//  TabBarViewController.swift
//  RxDemo
//
//  Created by Janzen on 2019/8/26.
//  Copyright © 2019 JanzenMacmini. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    // MARK: system cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor.blue
        
        delegate = self
        
        let homeVc = HomeViewController()// RxSwiftDemoViewController()//ViewController()
        let mineVc = MineViewController()
        
        let homeNaviVc = NavigationController(rootViewController: homeVc)
        homeNaviVc.tabBarItem.image = UIImage(named:"category")
        homeNaviVc.tabBarItem.selectedImage = UIImage(named: "category_active")
        homeNaviVc.title = "首页"
        
        let mineNaviVc = NavigationController(rootViewController: mineVc)
        mineNaviVc.tabBarItem.image = UIImage(named:"me")
        mineNaviVc.tabBarItem.selectedImage = UIImage(named: "me_active")
        mineNaviVc.title = "我的"
        
        viewControllers = [homeNaviVc,mineNaviVc]
        
    }

}


//MARK: - UITabBarControllerDelegate

extension TabBarViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let naviVc = viewController as? NavigationController else {
            return;
        }
        
        naviVc.popToRootViewController(animated: false)
    }
}
