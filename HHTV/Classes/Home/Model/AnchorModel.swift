//
//  AnchorModel.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/17.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

class AnchorModel: BaseModel {
    @objc var roomid : String = ""
    @objc var uid : String = ""
    @objc var pic51 : String = ""
    @objc var nickname : String = ""
    @objc var watch : Int = 0 // 浏览量
    @objc var live : Int = 0 // 是否在直播
    @objc var city : String = "" // 所在城市
}
