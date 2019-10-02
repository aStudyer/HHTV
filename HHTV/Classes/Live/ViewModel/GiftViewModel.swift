//
//  GiftViewModel.swift
//  XMGTV
//
//  Created by aStudyer on 16/11/13.
//  Copyright © 2016年 aStudyer. All rights reserved.
//

import UIKit

class GiftViewModel {
    lazy var giftlistData : [GiftPackage] = [GiftPackage]()
}

extension GiftViewModel {
    func loadGiftData(finishedCallback : @escaping () -> ()) {
        
        if giftlistData.count != 0 { finishedCallback() }
        
        NetworkTools.requestData(.get, URLString: "https://mbl.56.com/pay/v5/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150], finishedCallback: { result in
            guard let resultDict = result as? [String : Any] else { return }
            
            guard let dataDict = resultDict["message"] as? [String : Any] else { return }
            
            self.giftlistData.append(GiftPackage(dict: dataDict))
            
//            self.giftlistData = self.giftlistData.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            
            finishedCallback()
        })
    }
}
