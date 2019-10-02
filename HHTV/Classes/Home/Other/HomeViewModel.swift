//
//  HomeViewModel.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/17.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
//    https://mbl.56.com/home/v5/pageNewestAnchor.ios?page=1&product=ios&size=24
    func loadHomeData(page: Int = 1, finishedCallback: @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: "https://mbl.56.com/home/v5/pageNewestAnchor.ios", parameters: ["page" : page, "product" : "ios", "size" : 24], finishedCallback: { (result) -> Void in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
            
            for (_, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                self.anchorModels.append(anchor)
            }
            finishedCallback()
        })
    }
}
