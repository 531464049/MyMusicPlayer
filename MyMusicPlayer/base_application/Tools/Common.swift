//
//  Common.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 尺寸信息
let kScrWidth = UIScreen.main.bounds.size.width
let kScrHeight = UIScreen.main.bounds.size.height

func Width(_ x:CGFloat) -> CGFloat {
    return x * (kScrWidth / 375.0)
}

// MARK: - 是否是iphoneX
func k_is_iphoneX() -> Bool {
    if UIScreen.main.bounds.height == 812 {
        return true
    }
    return false
}

let NavHeight : CGFloat = (k_is_iphoneX() ? 88.0 : 64.0)
let TabBarHeight : CGFloat = (k_is_iphoneX() ? 83.0 : 49.0)
let K_StatusHeight : CGFloat = (k_is_iphoneX() ? 44.0 : 20.0)
let k_bottom_margin : CGFloat = (k_is_iphoneX() ? 34.0 : 0.0)

func FONT(_ size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: Width(size))
}
func B_FONT(_ size:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: Width(size))
}

// MARK: - app信息
func appName() -> String {
//    let nameKey = "CFBundleName"
//    let appName = Bundle.main.object(forInfoDictionaryKey: nameKey) as? String
//    return appName!
    //这里其实获取的是项目target的名称
    return "MyMusicPlayer"
}


