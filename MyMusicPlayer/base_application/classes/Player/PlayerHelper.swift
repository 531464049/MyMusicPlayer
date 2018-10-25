//
//  PlayerHelper.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

/// 播放模式：顺序，随机 单曲
enum PlayerListMode : Int {
    case order     = 0          //顺序播放
    case shuffle   = 1          //随机播放
    case single    = 2          //单曲循环
}

protocol PlayerHelperDelegate:NSObjectProtocol {
    //播放状态变更-是否在播放
    func playerPlayStateChange(isPlaying:Bool)
    //播放时间+进度变更
    func playerTimeProgressChange(curentTime:Int, totleTime:Int, progress:CGFloat)
    //music信息变更+歌单名称
    func playerMusicInfoChange(cModel:MusicModel, withDir dirName:String)
    //播放模式变更
    func playerPlsyModeChange(nMode:PlayerListMode)
}

/// 全局播放器状态
class PlayerHelper: NSObject {
    
    weak var delegate: PlayerHelperDelegate?
    
    var hasPlayerItem : Bool = false        //是否初始化了AVPlayerItem
    var isPlaying : Bool = false            //是否在播放
    var curentMusicName : String?           //当前播放音乐名称
    var curentMusicModel : MusicModel?      //当前music model
    var playMode : PlayerListMode = PlayerListMode.order   //播放模式
    var dirHelper = PlayerDirHelper()       //播放列表帮助
    
    //播放器相关
    private var playerItem : AVPlayerItem!
    private var player : AVPlayer!
    //时间 进度
    private var curentMusicTime : NSInteger = 0           //当前播放时间
    private var totalMusicTime : NSInteger = 0            //当前music总时间
    private var curentPlayProgress : CGFloat = 0.0  //当前播放进度
    
    
    /// 开始播放
    /// - Parameters:
    ///   - musicName: 音乐名称
    ///   - dirName: 歌单名称
    func play(musicName:String , withDirName dirName:String) {
        if (self.curentMusicName == musicName && self.dirHelper.dirName == dirName && self.curentPlayProgress < 1.0) {
            //当前播放与想要播放一样,且当前还没播放完
            return
        }
        //先清除全部
        clearAll()
        //更新播放器信息
        self.configState(musicName: musicName, withDirName: dirName)
        //再重新赋值
        let musicFullPath = "\(MHFileManager.documentsDir())/\(musicName)"
        let url = URL(fileURLWithPath: musicFullPath)
        self.playerItem = AVPlayerItem.init(url: url)
        
        //更新时间信息
        self.curentMusicTime = 0
        self.totalMusicTime = 0
        self.curentPlayProgress = 0.0
        
        self.player = AVPlayer.init(playerItem: self.playerItem)
        self.player.volume = 1.0
        
        self.addTimeObserve()
        self.playOrPause()
    }
    // MARK: - 播放/暂停
    func playOrPause() {
        if self.player != nil {
            if self.isPlaying == true {
                self.player.pause()
                self.isPlaying = false
            }else{
                self.player.play()
                self.isPlaying = true
            }
            // 注册后台播放
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
                try session.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
            if self.delegate != nil {
                self.delegate?.playerPlayStateChange(isPlaying: self.isPlaying)
            }
            self.setInfoCenterCredentials()
        }
    }
    // MARK: - 下一首
    func playNextSong() {
        var nextName = self.dirHelper.getNextSong(curentSongName: self.curentMusicName!, playMode: self.playMode)
        if nextName == nil {
            print("error 获取不到下一首.......")
            nextName = self.curentMusicName
        }
        self.play(musicName: nextName!, withDirName: self.dirHelper.dirName)
    }
    // MARK: - 上一首
    func playPreviousSong() {
        var preName = self.dirHelper.getPreviousSongName(curentSongName: self.curentMusicName!)
        if preName == nil {
            print("error 获取不到上一首.......")
            preName = self.curentMusicName
        }
        self.play(musicName: preName!, withDirName: self.dirHelper.dirName)
    }
    // MARK: - 改变播放模式  [顺序,随机,单曲]交替
    func changePlayerMode() {
        if self.playMode == PlayerListMode.order {
            self.playMode = PlayerListMode.shuffle
        }else if self.playMode == PlayerListMode.shuffle {
            self.playMode = PlayerListMode.single
        }else {
            self.playMode = PlayerListMode.order
        }
        UserDefaults.standard.set(self.playMode, forKey: "PlayerHelper.playMode")
        if self.delegate != nil {
            self.delegate?.playerPlsyModeChange(nMode: self.playMode)
        }
    }
    
    // MARK: - 添加播放进度观察者
    private func addTimeObserve() {
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main, using: { (aCMTime) in
            if self.player.currentItem?.status == .readyToPlay {
                //当前时间
                self.curentMusicTime = NSInteger(CMTimeGetSeconds(self.player.currentTime()))
                // 总时间
                self.totalMusicTime = NSInteger(CMTimeGetSeconds(self.playerItem.duration))
                //进度
                self.curentPlayProgress = CGFloat(self.curentMusicTime)/CGFloat(self.totalMusicTime)
                if (self.delegate != nil) {
                    self.delegate?.playerTimeProgressChange(curentTime: self.curentMusicTime, totleTime: self.totalMusicTime, progress: self.curentPlayProgress)
                }
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(curentmusicPlayEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillBackToHome), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        self.playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }

    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if (self.player.currentItem?.status == AVPlayerItemStatus.readyToPlay) {
                //当前playitem可以播放了
                self.setInfoCenterCredentials()
            }else if (self.player.currentItem?.status == AVPlayerItemStatus.failed) {
                //播放失败？？
                print("\(self.playerItem.error.debugDescription)")
                self.curentMusicPlayFailed()
            }
        }
    }
    // MARK: - 处理播放失败
    private func curentMusicPlayFailed() {
        //弹窗提示？删除歌曲？
        //如果歌单内只有一首，暂停
        if MusicDirHelper.getDirMusicNameList(self.dirHelper.dirName).count <= 1 {
            //歌单内小于等于1首
            //怎么办，就这一首歌，还播放失败了？？？？？？
        }else{
            self.playNextSong()
        }
        
    }
    // MARK: - 通知 当前music播放结束
    @objc private func curentmusicPlayEnd() {
        self.playNextSong()
    }
    // MARK: - 通知 app进入后台
    @objc private func appWillBackToHome() {
        if self.hasPlayerItem {
            //更新后台播放显示信息
            self.setInfoCenterCredentials()
        }
    }

    //MARK: - 更新播放器信息
    private func configState(musicName:String , withDirName dirName:String) {
        self.curentMusicName = musicName
        self.dirHelper.updateDirName(name: dirName)
        self.dirHelper.addPlayedList(played: musicName)
        MusicHelper.getMusicModel(musicName) { (model) in
            self.curentMusicModel = model
            if self.delegate != nil {
                self.delegate?.playerMusicInfoChange(cModel: self.curentMusicModel!, withDir: self.dirHelper.dirName)
            }
        }
        self.hasPlayerItem = true
    }
    
    //MARK: - 设置后台播放显示信息
    private func setInfoCenterCredentials() {
        let mpic = MPNowPlayingInfoCenter.default()
        //专辑封面
        let albumImg : UIImage!
        if self.curentMusicModel?.artworkImg != nil {
            albumImg = self.curentMusicModel?.artworkImg
        }else{
            albumImg = UIImage(named: "face_01")
        }
        let albumArt = MPMediaItemArtwork.init(image: albumImg)
        //进度
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: self.curentMusicModel?.musicName ?? "歌曲名未知",
                               MPMediaItemPropertyArtist: "\(self.curentMusicModel?.singerName ?? "未知歌手")-\(self.curentMusicModel?.albumName ?? "未知专辑")",
                               MPMediaItemPropertyArtwork: albumArt,
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: Double(self.curentMusicTime),
                               MPMediaItemPropertyPlaybackDuration: Double(self.totalMusicTime),
                               MPNowPlayingInfoPropertyPlaybackRate: self.isPlaying ? 1 : 0]
    }

    //MARK: - 清空之前播放的内容+通知
    private func clearAll() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        if self.playerItem != nil {
            self.playerItem.removeObserver(self, forKeyPath: "status")
            self.playerItem = nil
        }

        if self.player != nil {
            self.player.pause()
            self.player.replaceCurrentItem(with: nil)
            self.player = nil
        }
        self.isPlaying = false
        if self.delegate != nil {
            self.delegate?.playerPlayStateChange(isPlaying: self.isPlaying)
        }
    }
    deinit {
        clearAll()
    }

    // MARK: - 单例
    static var sharedInstance: PlayerHelper {
        struct Static {
            static let instance: PlayerHelper = PlayerHelper()
        }
        return Static.instance
    }
    override init() {
        super.init()
        if (UserDefaults.standard.object(forKey: "PlayerHelper.playMode") != nil) {
            let mode = UserDefaults.standard.object(forKey: "PlayerHelper.playMode") as! PlayerListMode
            self.playMode = mode
        }else{
            self.playMode = .order
        }
    }
    
}
