//
//  MusicDirModel.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/12.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class MusicDirModel: NSObject {
    var dirName : String = ""       //歌单名
    var musicNum : Int = 0        //歌曲数量
    var dirIcon : UIImage?     //歌单封面图
    var isPlayIng : Bool = false   //是否在播放该歌单

}
