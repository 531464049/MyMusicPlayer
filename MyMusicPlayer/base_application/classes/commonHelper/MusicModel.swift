//
//  MusicModel.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/10.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit
import AVFoundation

class MusicModel: NSObject , NSCoding{
    var musicName : String = ""   //歌名
    var singerName : String = "" //歌手
    var artworkImg : UIImage?     //封面图
    var albumName : String = ""   //专辑名
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(musicName, forKey: "musicName")
        aCoder.encode(singerName, forKey: "singerName")
        aCoder.encode(artworkImg, forKey: "artworkImg")
        aCoder.encode(albumName, forKey: "albumName")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        musicName = aDecoder.decodeObject(forKey: "musicName") as! String
        singerName = aDecoder.decodeObject(forKey: "singerName") as! String
        albumName = aDecoder.decodeObject(forKey: "albumName") as! String
        artworkImg = aDecoder.decodeObject(forKey: "artworkImg") as? UIImage
    }
    override init() {
        super.init()
    }
    // MARK: - 获取mp3文件信息（封面图，专辑信息的）
    class func getMusicInfo(path:String) -> MusicModel {
        let model = MusicModel()
        let fileFullPath = "\(MHFileManager.documentsDir())/\(path)"
        let url = URL.init(fileURLWithPath: fileFullPath)
        let mp3Asset = AVURLAsset.init(url: url, options: nil)
        
        for formart : AVMetadataFormat in mp3Asset.availableMetadataFormats {
            for metadataItem : AVMetadataItem in mp3Asset.metadata(forFormat: formart) {
                if metadataItem.keySpace != AVMetadataKeySpace.id3 {
                    continue
                }
                let commonKey = metadataItem.commonKey
                if commonKey == AVMetadataKey.commonKeyTitle {
                    //歌名
                    model.musicName = metadataItem.value as! String
                }
                if commonKey == AVMetadataKey.commonKeyArtist {
                    //歌手名
                    model.singerName = metadataItem.value as! String
                }
                if commonKey == AVMetadataKey.commonKeyAlbumName {
                    //专辑名
                    model.albumName = metadataItem.value as! String
                }
                if commonKey == AVMetadataKey.commonKeyArtwork {
                    //封面图
                    let imgData = metadataItem.value?.copy(with: nil) as! Data
                    model.artworkImg = UIImage.init(data: imgData)
                }
            }
        }
        //将获取到的model缓存起来
        MusicHelper.yyCache().setObject(model, forKey: path)
        return model
    }

    
}
