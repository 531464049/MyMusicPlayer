//
//  PlayerDirHelper.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/17.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

/// 播放列表处理
class PlayerDirHelper: NSObject {
    var dirName : String = ""                 //歌单名称
    var playedList = [String]()               //当前歌单已播放名字列表
    
    
    //MARK: - 获取下一首名字
    func getNextSong(curentSongName:String , playMode:PlayerListMode) -> String? {
        let dirMusicArr = MusicDirHelper.getDirMusicNameList(self.dirName)
        if dirMusicArr.count == 0 {
            return nil
        }
        //下一个下标
        var nextIndex = 0
        if dirMusicArr.count == 1 {
            nextIndex = 0
        }else{
            //当前下标
            var curentIndex = dirMusicArr.index(of: curentSongName)
            if curentIndex == nil {//如果当前下标不存在，将下标变为最后一个
                curentIndex = dirMusicArr.count-1
            }
            if playMode == PlayerListMode.order {//顺序播放
                if curentIndex == dirMusicArr.count-1 {
                    nextIndex = 0
                }else{
                    nextIndex = curentIndex!+1
                }
            }
            if playMode == PlayerListMode.shuffle {//随机播放
                let randomNumber:Int = Int(arc4random_uniform(UInt32(dirMusicArr.count)))
                nextIndex = randomNumber
            }
            if playMode == PlayerListMode.single {//单曲循环
                nextIndex = curentIndex!
            }
        }
        return dirMusicArr[nextIndex]
    }
    // MARK: - 上一首
    func getPreviousSongName(curentSongName:String) -> String? {
        if self.playedList.count > 1 {
            let preName = self.playedList[self.playedList.count - 2]
            self.playedList.removeLast()
            return preName
        }
        let dirMusicArr = MusicDirHelper.getDirMusicNameList(self.dirName)
        if dirMusicArr.count == 0 {
            return nil
        }
        //上一个下标
        var preIndex = 0
        if dirMusicArr.count == 1 {
            preIndex = 0
        }else{
            var curentIndex = dirMusicArr.index(of: curentSongName)
            if curentIndex == nil {//如果当前下标不存在，将下标变为最后一个
                curentIndex = 0
            }
            if curentIndex == 0 {
                preIndex = dirMusicArr.count-1
            }else{
                preIndex = curentIndex!-1
            }
        }
        return dirMusicArr[preIndex]
    }
    //MARK: - 添加已播放歌曲
    func addPlayedList(played:String) {
        self.playedList.append(played)
    }
    
    //MARK: - 歌单名称变更
    func updateDirName(name:String) {
        if self.dirName != name {
            self.dirName = name
            self.playedList.removeAll()
        }
    }
}
