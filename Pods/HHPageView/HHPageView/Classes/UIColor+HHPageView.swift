//
//  UIColor+HHPageView.swift
//  HHPageView
//
//  Created by aStudyer on 2019/9/14.
//

import UIKit

public extension UIColor {
    func colorSpaceModel() -> CGColorSpaceModel? {
        return self.cgColor.colorSpace?.model
    }
    
    func red() -> CGFloat {
        let c = self.cgColor.components!
        return c[0];
    }
    
    func green() -> CGFloat {
        let c = self.cgColor.components!
        if (colorSpaceModel() == .monochrome) {
            return c[0];
        }
        return c[1];
    }
    
    func blue() -> CGFloat {
        let c = self.cgColor.components!
        if (colorSpaceModel() == .monochrome) {
            return c[0];
        }
        return c[2];
    }
    
    func alpha() -> CGFloat {
        let c = self.cgColor.components!
        return c[self.cgColor.numberOfComponents - 1];
    }
    
    func reverseColor() -> UIColor {
        let r = 1 - red();
        let g = 1 - green();
        let b = 1 - blue();
        let a = alpha();
        return UIColor(r: r, g: g, b: b, alpha: a);
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
