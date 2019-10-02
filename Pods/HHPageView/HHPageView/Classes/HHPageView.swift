//
//  HHPageView.swift
//  HHPageView
//
//  Created by aStudyer on 2019/9/14.
//

import UIKit

public class HHPageView: UIView {
    // MARK: 定义属性
    fileprivate var titles: [String]!
    fileprivate var style: HHTitleStyle!
    fileprivate var childVcs: [UIViewController]!
    fileprivate weak var parentVc: UIViewController!
    
    fileprivate var titleView: HHTitleView!
    fileprivate var contentView: HHContentView!
    
    // MARK: 自定义构造函数
    public init(frame: CGRect, titles: [String], style: HHTitleStyle, childVcs: [UIViewController], parentVc: UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置界面内容
extension HHPageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = HHTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = HHContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

// MARK:- 设置HHContentView的代理
extension HHPageView: HHContentViewDelegate {
    func contentView(_ contentView: HHContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: HHContentView) {
        titleView.contentViewDidEndScroll()
    }
}

// MARK:- 设置HHTitleView的代理
extension HHPageView: HHTitleViewDelegate {
    func titleView(_ titleView: HHTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
