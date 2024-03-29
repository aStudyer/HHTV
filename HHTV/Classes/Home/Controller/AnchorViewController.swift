//
//  AnchorViewController.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/16.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"

class AnchorViewController: UIViewController {
    
    // MARK: 对外属性
    var homeType : HomeType!
    
    // MARK: 定义属性
    private var page: Int = 1
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData(page: page)
    }
    
}


// MARK:- 设置UI界面内容
extension AnchorViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension AnchorViewController {
    fileprivate func loadData(page : Int) {
        homeVM.loadHomeData(page: page, finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}

// MARK:- collectionView的数据源&代理
extension AnchorViewController : UICollectionViewDataSource, WaterfallLayoutDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeViewCell
        
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        
        if indexPath.item == homeVM.anchorModels.count - 1 {
            page = page + 1
            loadData(page: page)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomViewController()
        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}
