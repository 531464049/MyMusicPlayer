//
//  MusicHelper.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/11.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit
import AVFoundation

/*
 保存全部歌单列表（每个歌单是一个对象-【名字，数量，图标】）
 每个歌单对应一个数组-歌曲列表
 每个歌曲对应一个对象-【歌曲信息】
 */
final class MusicHelper: NSObject {

    class func yyCache() -> YYCache {
        return YYCache.init(name: "com.myMusicData.cache")!
    }
    
    /// 根据名称获取音乐model
    ///   - musicName: name
    ///   - callBack: 回调model
    class func getMusicModel(_ musicName:String , withCallBack callBack:(_ model:MusicModel) -> Void) {
        var model = MusicModel()
        let cacheModel = MusicHelper.yyCache().object(forKey: musicName)
        if cacheModel != nil {
            model = cacheModel as! MusicModel
            callBack(model)
        }else{
            model = MusicModel.getMusicInfo(path: musicName)
            callBack(model)
        }
    }
    
    /// 根据名称获取model
    /// - Parameter musicName: 音乐名称
    /// - Returns: model
    class func getMusicModel(_ musicName:String) -> MusicModel {
        var model = MusicModel()
        let cacheModel = MusicHelper.yyCache().object(forKey: musicName)
        if cacheModel != nil {
            model = cacheModel as! MusicModel
            return model
        }else{
            model = MusicModel.getMusicInfo(path: musicName)
            return model
        }
    }
    
    // MARK: - 获取全部music信息
    class func updateAllMusicInfo(callBack:@escaping () -> Void) {
        DispatchQueue.global().async {
            let allArr = MusicHelper.getDocumentAllMusicNameList()
            for name in allArr {
                if MusicHelper.yyCache().object(forKey: name) != nil {
                    continue
                }
                _ = MusicModel.getMusicInfo(path: name)
            }
            DispatchQueue.main.async {
                callBack()
            }
        }
    }
    // MARK: - 读取本地全部mp3文件名字列表
    class func getDocumentAllMusicNameList() -> [String]{
        var namelist = [String]()
        do {
            let array = try FileManager.default.subpathsOfDirectory(atPath: MHFileManager.documentsDir())
            for fileName in array {
                if fileName.lowercased().hasSuffix(".mp3") {
                    namelist.append(fileName)
                }
            }
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        return namelist
    }
}
