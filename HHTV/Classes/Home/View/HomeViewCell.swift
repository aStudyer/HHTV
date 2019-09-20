//
//  HomeViewCell.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/17.
//  Copyright © 2019 coderwhy. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    // MARK: 定义属性
    var anchorModel : AnchorModel? {
        didSet {
            albumImageView.setImage(anchorModel?.pic51, "home_pic_default.jpeg")
            liveImageView.isHidden = anchorModel?.live == 0
            nickNameLabel.text = anchorModel?.nickname
            onlinePeopleLabel.setTitle("\(anchorModel?.watch ?? 0)", for: .normal)
        }
    }
}
