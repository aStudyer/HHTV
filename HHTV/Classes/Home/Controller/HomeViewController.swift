//
//  HomeViewController.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/14.
//  Copyright © 2019 coderwhy. All rights reserved.
//

import UIKit
import HHPageView

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    private func setupUI() {
        setupNavigationBar()
        setupContentView()
    }
    
    private func setupNavigationBar() {
        // 1.左侧logoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        // 2.设置右侧收藏的item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        // 事件监听 --> 发送消息 --> 将方法包装SEL  --> 类方法列表 --> IMP
        
        // 3.搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: 300, height: 44)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        navigationItem.titleView = searchBar
    }
    
    private func setupContentView() {
        // 1.获取数据
        let homeTypes = loadTypesData()
        
        // 2.创建主题内容
        let style = HHPageStyle()
        style.isScrollEnable = true
        style.titleViewHeight = 44
        style.bottomLineColor = UIColor.blue
        var pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - tabBarController!.tabBar.frame.height)
        if #available(iOS 11, *) {
            pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH + 10, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - tabBarController!.tabBar.frame.height)
        }
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = HHPageView(frame: pageFrame, titles: titles, titleStyle: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        for dict in dataArray {
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
}

// MARK: - 事件监听函数
extension HomeViewController {
    @objc private func followItemClick() {
        print("------")
    }
}
