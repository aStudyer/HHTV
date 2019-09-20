//
//  HHPageStyle.swift
//  HHPageView
//
//  Created by aStudyer on 2019/9/14.
//
import UIKit

public class HHPageStyle {
    public var titleViewHeight: CGFloat = 44
    public var titleViewBackgroundColor: UIColor = UIColor.white
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    public var isScrollEnable: Bool = true
    public var titleMargin: CGFloat = 20
    
    public var normalColor: UIColor = UIColor.darkGray
    public var selectColor: UIColor = UIColor.black
    
    public var isShowBottomLine: Bool = true
    public var bottomLineColor: UIColor = UIColor.black
    public var bottomLineHeight: CGFloat = 2
    
    public var isTitleScale: Bool = false
    public var scaleRange: CGFloat = 1.2
    
    public var isShowCoverView: Bool = false
    public var coverBgColor: UIColor = UIColor.lightGray
    public var coverAlpha: CGFloat = 0.4
    public var coverMargin: CGFloat = 8
    public var coverHeight: CGFloat = 25
    
    public init() {
        
    }
}
