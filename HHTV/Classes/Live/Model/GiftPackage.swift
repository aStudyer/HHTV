//
//  GiftPackage.swift
//  XMGTV
//
//  Created by aStudyer on 16/11/13.
//  Copyright © 2016年 aStudyer. All rights reserved.
//

import UIKit

class GiftPackage: BaseModel {
    var t : Int = 0
    var list : [GiftModel] = [GiftModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArray = value as? [[String : Any]] {
                for listDict in listArray {
                    list.append(GiftModel(dict: listDict))
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
