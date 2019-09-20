//
//  BaseModel.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/17.
//  Copyright © 2019 coderwhy. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {
        super.init()
    }
    
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        print("undefinedKey = \(key)")
    }
}
