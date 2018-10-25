//
//  PopupInfoView.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/24.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

/// 选中类型
enum PopInfoSelected : Int {
    case none                = 0   //无操作
    case play                = 1   //播放
    case collectToDir        = 2   //收藏到歌单
    case share               = 3   //分享
    case singer              = 4   //歌手
    case album               = 5   //专辑
    case delect              = 6   //删除
}

typealias tapCallBack = (_ selected:PopInfoSelected) -> Void

//歌名+收藏到歌单+分享？+歌手+专辑+删除
class PopupInfoView: BaseView {
    
    private var musicModel = MusicModel()
    private var callBack : tapCallBack?
    private var contentView = UIView()
    
    private init(frame:CGRect,musicName:String) {
        super.init(frame: frame)
        self.musicModel = MusicHelper.getMusicModel(musicName)
        commitUI()
    }
    // MARK: - 初始化UI
    private func commitUI() {
        let hidenControl = UIControl.init(frame: self.bounds)
        hidenControl.backgroundColor = UIColor.black
        hidenControl.alpha = 0.2
        hidenControl.addTarget(self, action: #selector(hiden_hiden_hiden), for: UIControlEvents.touchUpInside)
        self.addSubview(hidenControl)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: kScrHeight, width: kScrWidth, height: 300))
        self.contentView.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.masksToBounds = true
        self.addSubview(self.contentView)
        
        let tips = ["播放 \(self.musicModel.musicName)","收藏到歌单","分享","歌手：\(self.musicModel.singerName)","专辑：\(self.musicModel.albumName)","删除"]
        let icons = ["playThisOne","addToCollect","share","theSinger","theAlbum","delectedThis"]
        for index in (0..<6) {
            let str = tips[index]
            let item = UIView.init(frame: CGRect(x: 0, y: CGFloat(50*index), width: kScrWidth, height: 50))
            item.backgroundColor = UIColor.white
            self.contentView.addSubview(item)
            
            let img = UIImageView.init(frame: CGRect(x: 12, y: 12, width: 26, height: 26))
            img.image = UIImage.init(named: icons[index])
            img.clipsToBounds = true
            img.contentMode = UIViewContentMode.scaleAspectFit
            item.addSubview(img)
            
            let title = UILabel.init(frame: CGRect(x: 50, y: 10, width: kScrWidth-70, height: 30))
            title.text = str
            title.textColor = UIColor.red
            title.font = FONT(14)
            title.textAlignment = NSTextAlignment.left
            item.addSubview(title)
            
            if index < 5 {
                let line = UIView.init(frame: CGRect(x: 50, y: 49.3, width: kScrWidth-70, height: 0.5))
                line.backgroundColor = UIColor.baseColor()
                line.alpha = 0.5
                item.addSubview(line)
            }
        }
        
        showUp()
    }
    // MARK: - 弹出动画
    private func showUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 0, y: kScrHeight-300, width: kScrWidth, height: 300)
        }) { (finished) in
            
        }
    }
    // MARK: - 退出
    @objc private func hiden_hiden_hiden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame = CGRect(x: 0, y: kScrHeight, width: kScrWidth, height: 300)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    // MARK: - 弹出界面
    class func showPopUpInfo(name:String , withCallBack callBack:@escaping tapCallBack) {
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow == nil {
            keyWindow = UIApplication.shared.windows.first
        }
        let pop = PopupInfoView.init(frame: CGRect(x: 0, y: 0, width: kScrWidth, height: kScrHeight), musicName: name)
        pop.callBack = callBack
        keyWindow?.addSubview(pop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
