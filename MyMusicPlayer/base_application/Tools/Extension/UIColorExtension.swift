//
//  UIColorExtension.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    class func hex(_ hex:UInt, _ alpha:CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
                            blue: CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
                            alpha: alpha)
    }
    class func rgba(_ r:CGFloat , _ g:CGFloat , _ b:CGFloat , _ a:CGFloat) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    class func rgb(_ r:CGFloat , _ g:CGFloat , _ b:CGFloat) -> UIColor {
        return UIColor.rgba(r/255.0, g/255.0, b/255.0, 1.0)
    }
    class func baseColor() -> UIColor {
        return UIColor.rgb(22, 9, 11)
    }
}
