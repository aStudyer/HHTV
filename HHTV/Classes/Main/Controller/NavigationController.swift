//
//  NavigationController.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/14.
//  Copyright © 2019 coderwhy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFullScreenPop()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 私有方法
extension NavigationController {
    /// 添加全屏pop手势
    private func addFullScreenPop() {
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [NSObject] else {
            return
        }
        let targetObjc = targets.first
        let target = targetObjc?.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }
}
