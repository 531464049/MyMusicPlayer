//
//  MyTool.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/17.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class MyTool: NSObject {
    
    //MARK: - 时间转换 "00:00"
    class func formatPlayTime(secounds:NSInteger)->String{
        let Min = NSInteger(secounds / 60)
        let Sec = NSInteger(secounds % 60)
        return String(format: "%02d:%02d", Min, Sec)
    }
    
}
