//
//  GiftListView.swift
//  HHTV
//
//  Created by aStudyer on 2019/10/1.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit
import HHPageView

private let kGiftCellID = "kGiftCellID"

protocol GiftListViewDelegate: class {
    func giftListView(giftView: GiftListView, giftModel : GiftModel)
}

class GiftListView: UIView, NibLoadable {
    // MARK: 控件属性
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    fileprivate var pageCollectionView: HHPageCollectionView!
    fileprivate var currentIndexPath: IndexPath?
    fileprivate var giftVM: GiftViewModel = GiftViewModel()
    
    weak var delegate: GiftListViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.初始化礼物的View
        setupUI()
        
        // 2.加载礼物的数据
        loadGiftData()
    }
}

extension GiftListView {
    fileprivate func setupUI() {
        setupGiftView()
    }
    
    fileprivate func setupGiftView() {
        let style = HHTitleStyle()
        style.isScrollEnable = false
        style.isShowBottomLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        style.titleHeight = 0
        
        let layout = HHPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionView = HHPageCollectionView(frame: pageViewFrame, titles: [], style: style, isTitleInTop: true, layout : layout)
        giftView.addSubview(pageCollectionView)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.backgroundColor = UIColor(hex: "2f2c23")
        pageCollectionView.register(nibName: "GiftViewCell", identifier: kGiftCellID)
    }
}

// MARK:- 加载数据
extension GiftListView {
    fileprivate func loadGiftData() {
        giftVM.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}

// MARK:- 数据设置
extension GiftListView: HHPageCollectionViewDataSource, HHPageCollectionViewDelegate {
    func numberOfSections(in pageCollectionView: HHPageCollectionView) -> Int {
        return giftVM.giftlistData.count
    }
    
    func pageCollectionView(_ collectionView: HHPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = giftVM.giftlistData[section]
        return package.list.count
    }
    
    func pageCollectionView(_ pageCollectionView: HHPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftCellID, for: indexPath) as! GiftViewCell
        let package = giftVM.giftlistData[indexPath.section]
        cell.giftModel = package.list[indexPath.item]
        
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: HHPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        sendGiftBtn.isEnabled = true
        currentIndexPath = indexPath
    }
}

// MARK:- 送礼物
extension GiftListView {
    @IBAction func sendGiftBtnClick() {
        let package = giftVM.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftView: self, giftModel: giftModel)
    }
}
