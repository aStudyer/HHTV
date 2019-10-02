//
//  NibLoadable.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/29.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

protocol NibLoadable {

}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}

