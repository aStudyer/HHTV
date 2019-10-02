//
//  EmoticonViewCell.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/30.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var emoticon : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
}
