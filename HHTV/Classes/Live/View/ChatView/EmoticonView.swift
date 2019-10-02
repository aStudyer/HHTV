//
//  EmoticonView.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/30.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit
import HHPageView

private let kEmoticonCellID = "kEmoticonCellID"

class EmoticonView: UIView {
    
    var emoticonClickCallback : ((Emoticon) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EmoticonView {
    fileprivate func setupUI() {
        // 1.创建HHPageCollectionView
        let style = HHTitleStyle()
        style.isShowBottomLine = true
        let layout = HHPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = HHPageCollectionView(frame: bounds, titles: ["普通", "粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        
        // 2.将pageCollectionView添加到view中
        addSubview(pageCollectionView)
        
        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nibName: "EmoticonViewCell", identifier: kEmoticonCellID)
    }
}

extension EmoticonView : HHPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: HHPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ collectionView: HHPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: HHPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}


extension EmoticonView : HHPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: HHPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
}
