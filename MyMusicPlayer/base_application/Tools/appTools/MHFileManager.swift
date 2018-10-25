//
//  MHFileManager.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/11.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class MHFileManager: NSObject {
    
    /// app沙盒-documents路径
    /// - Returns: documents路径
    class func documentsDir() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentPath
    }
    
    /// app沙盒-caches路径
    /// - Returns: caches路径
    class func cachesDir() -> String {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return cachesPath
    }
    
}
