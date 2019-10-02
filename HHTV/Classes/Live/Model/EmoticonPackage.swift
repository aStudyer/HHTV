//
//  EmoticonPackage.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/30.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import Foundation

class EmoticonPackage {
    
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}
