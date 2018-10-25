//
//  MusicDirHelper.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit


/// 创建歌单回调状态
enum DirCreatState : Int {
    case success = 0         //创建成功
    case failed =  1         //创建失败
    case hasSameDir = 2      //存在相同歌单
}
/// 歌单添加音乐状态
enum DirAddMusicState : Int {
    case success = 0            //歌单添加音乐成功
    case failed = 1             //歌单添加音乐失败
    case hasSameMusic = 2       //存在相同名字music
}

class MusicDirHelper: NSObject {
    //歌单【本地音乐】 不可修改
    
    // MARK: - 读取歌单model列表
    class func getMusicDirList() -> [MusicDirModel] {
        let dirsArr = NSMutableArray()
        //存储路径
        let path = MusicDirHelper().dirListPlistPath()
        //读取数据
        let cacheArr = NSArray(contentsOfFile: path)
        if (cacheArr != nil) {
            dirsArr.addObjects(from: cacheArr as! [Any])
        }
        
        //当dirsArr为空时，代表第一次开启，手动添加一个本地音乐歌单
        if (dirsArr.count == 0) {
            let locolDir : [String : Any] = [
                "name":"本地音乐",
                "num":0,
                "iconName":"face_01"
            ]
            //添加一个本地音乐歌单，并保存
            dirsArr.add(locolDir)
            dirsArr.write(toFile: path, atomically: true)
        }
        
        //遍历dirsArr
        var allmusicDirs = [MusicDirModel]()
        for item in dirsArr {
            let dic = item as! [String:Any]
            let model = MusicDirModel()
            model.dirName = dic["name"] as! String
            if model.dirName == "本地音乐" {
                model.musicNum = MusicHelper.getDocumentAllMusicNameList().count
            }else{
                model.musicNum = dic["num"] as! Int
            }
            model.dirIcon = UIImage.init(named: dic["iconName"] as! String)
            model.isPlayIng = false
            allmusicDirs.append(model)
        }
        return allmusicDirs
    }
    // MARK: - 根据歌单名字，获取歌单音乐model列表
    class func getDirmusicModels(_ dirName:String , withCallBack callBack:@escaping (_ models:[MusicModel]) -> Void) {
        DispatchQueue.global().async {
            var modelArr = [MusicModel]()
            let musicNames = MusicDirHelper.getDirMusicNameList(dirName)
            for name in musicNames {
                let model = MusicHelper.yyCache().object(forKey: name)
                if model != nil {
                    modelArr.append(model as! MusicModel)
                    continue
                }

                let getModel = MusicModel.getMusicInfo(path: name)
                modelArr.append(getModel)
            }
            DispatchQueue.main.async {
                callBack(modelArr)
            }
        }
    }
    
    // MARK: - 根据歌单名字，获取歌单音乐名列表
    class func getDirMusicNameList(_ dirName:String) -> [String] {
        var namesArr = [String]()
        //本地音乐，直接返回
        if (dirName == "本地音乐") {
            namesArr = MusicHelper.getDocumentAllMusicNameList()
            return namesArr
        }
        
        let dirPath = MusicDirHelper().getMusicDirPlistPath(dirName)
        let cacheList = NSArray.init(contentsOfFile: dirPath)
        if cacheList != nil {
            let arrr = cacheList as! [String]
            namesArr += arrr
        }
        return namesArr
    }
    
    // MARK: - 添加音乐到歌单
    class func addMusicToDir(_ musicName:String , withDirName dirName:String ,withCallBack callBack:(_ state:DirAddMusicState , _ msg:String) -> Void) {
        var namesArr = getDirMusicNameList(dirName)
        for name in namesArr {
            if name == musicName {
                callBack(DirAddMusicState.hasSameMusic,"该歌单已存在相同名字歌曲")
                return
            }
        }
        namesArr.insert(dirName, at: 0)
        let fanished = (namesArr as NSArray).write(toFile: MusicDirHelper().getMusicDirPlistPath(dirName), atomically: true)
        if fanished == true {
            callBack(DirAddMusicState.success,"添加成功")
        }
        callBack(DirAddMusicState.failed,"添加失败，具体为啥我也不清楚")
    }
    
    // MARK: - 创建歌单 回调[是否创建成功，msg]
    class func creatMusicDir(_ dirName:String , withCallBack callBack:(_ state:DirCreatState , _ msg:String?) -> Void) {
        let dirArr = NSMutableArray.init()
        let cachePath = MusicDirHelper().dirListPlistPath()
        let cacheArr = NSArray(contentsOfFile: cachePath)
        if cacheArr != nil {
            dirArr.addObjects(from: cacheArr as! [Any])
        }
        
        //查询-是否已存在相同歌单
        for item in dirArr {
            let dic = item as! [String:Any]
            let itemName = dic["name"] as! String
            if itemName == dirName {
                callBack(DirCreatState.hasSameDir,"已存在相同名字歌单")
                return
            }
        }
        
        //添加歌单
        let nextIndex = (dirArr.count + 1) % 10
        let addDir : [String : Any] = [
            "name":dirName,
            "num":0,
            "iconName":String(format: "face_%02d", nextIndex)
        ]
        dirArr.add(addDir)
        //保存
        let addFinished = dirArr.write(toFile:cachePath, atomically: true)
        if (addFinished == true) {
            callBack(DirCreatState.success,"创建歌单成功")
        }else{
            callBack(DirCreatState.failed,"创建歌单失败")
        }
    }
    
    // MARK: - private method
    // MARK: - 歌单列表plist文件路径
    private func dirListPlistPath() -> String {
        let cacheFolderPath = dirsPath()
        do {
            try FileManager.default.createDirectory(atPath: cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            
            return "\(cacheFolderPath)/musicDirs.plist"
        } catch let error as NSError {
            print("\(error)")
            return ""
        }
    }
    // MARK: - 根据歌单名字，获取歌单列表文件对应的路径
    private func getMusicDirPlistPath(_ dirName:String) -> String {
        let cacheFolderPath = dirsPath()
        do {
            try FileManager.default.createDirectory(atPath: cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            return "\(cacheFolderPath)/\(dirName.md5()).plist"
        } catch let error as NSError {
            print("\(error)")
            return ""
        }
    }
    // MARK: - 歌单存储主文件夹路径
    private func dirsPath() -> String {
        let documentDir = MHFileManager.documentsDir()
        let cacheFolderPath = "\(documentDir)/dirPlist"
        return cacheFolderPath
    }
}
