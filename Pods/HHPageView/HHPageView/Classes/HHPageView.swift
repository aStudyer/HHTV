//
//  HHPageView.swift
//  HHPageView
//
//  Created by aStudyer on 2019/9/14.
//

import UIKit

public class HHPageView: UIView {
    // MARK: 定义属性
    private var titles: [String]
    private var childVcs: [UIViewController]
    private var parentVc: UIViewController
    private var titleStyle: HHPageStyle
    
    // MARK: 构造函数
    public init(frame: CGRect, titles: [String], titleStyle: HHPageStyle, childVcs: [UIViewController], parentVc: UIViewController) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        parentVc.automaticallyAdjustsScrollViewInsets = false
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI界面
extension HHPageView {
    private func setupUI() {
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        let titleView = HHTitleView(frame: titleViewFrame, titles: titles, style: titleStyle)
        addSubview(titleView)
        titleView.backgroundColor = titleStyle.titleViewBackgroundColor
        
        // 2.添加contentView到pageView中
        let contentViewFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: frame.height - titleViewFrame.height)
        let contentView = HHContentView(frame: contentViewFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        
        // 3.设置contentView&titleView关系
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
