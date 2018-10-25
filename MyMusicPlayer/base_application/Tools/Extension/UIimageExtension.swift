//
//  UIimageExtension.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/4.
//  Copyright © 2018年 马浩. All rights reserved.
//

import Foundation

extension UIImage {
    class func makeImage(_ color:UIColor , _ size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
