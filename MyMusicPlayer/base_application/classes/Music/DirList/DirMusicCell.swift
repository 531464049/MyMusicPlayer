//
//  DirMusicCell.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

typealias musicTapCallBack = (_ musicModel:MusicModel) -> Void

class DirMusicCell: CommonCell {
    
    var tapCallBack : musicTapCallBack?
    
    
    private var musicIcon = UIImageView()
    private var musicNameLab = UILabel()
    private var singerAndalbumNamelab = UILabel()
    private var moreIcon = UIImageView()
    private var actionBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.musicIcon = UIImageView.init(frame: CGRect.zero)
        self.musicIcon.contentMode = UIViewContentMode.scaleAspectFill
        self.musicIcon.clipsToBounds = true
        self.musicIcon.layer.cornerRadius = 5;
        self.musicIcon.layer.masksToBounds = true
        self.contentView.addSubview(self.musicIcon)
        
        self.musicNameLab = UILabel.init(frame: CGRect.zero)
        self.musicNameLab.textColor = UIColor.white
        self.musicNameLab.textAlignment = NSTextAlignment.left
        self.musicNameLab.font = FONT(16)
        self.musicNameLab.numberOfLines = 1
        self.contentView.addSubview(self.musicNameLab)
        
        self.singerAndalbumNamelab = UILabel.init(frame: CGRect.zero)
        self.singerAndalbumNamelab.textColor = UIColor.white
        self.singerAndalbumNamelab.textAlignment = NSTextAlignment.left
        self.singerAndalbumNamelab.font = FONT(13)
        self.singerAndalbumNamelab.numberOfLines = 1
        self.contentView.addSubview(self.singerAndalbumNamelab)
        
        self.moreIcon = UIImageView.init(frame: CGRect.zero)
        self.moreIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.moreIcon.image = UIImage.init(named: "musiclistMore")
        self.moreIcon.clipsToBounds = true
        self.contentView.addSubview(self.moreIcon)
        
        self.actionBtn = UIButton.init(type: .custom)
        self.actionBtn.backgroundColor = UIColor.clear
        self.actionBtn.addTarget(self, action: #selector(more_item_tap), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(self.actionBtn)
        
        _=self.musicIcon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.bottomSpaceToView(self.contentView,10)?.widthEqualToHeight()
        _=self.musicNameLab.sd_layout().leftSpaceToView(self.musicIcon,10)?.topSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,60)?.heightIs(30)
        _=self.singerAndalbumNamelab.sd_layout().leftSpaceToView(self.musicIcon,10)?.bottomSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,60)?.heightIs(20)
        _=self.moreIcon.sd_layout().rightSpaceToView(self.contentView,16)?.centerYEqualToView(self.contentView)?.widthIs(18)?.heightEqualToWidth()
        _=self.actionBtn.sd_layout().rightSpaceToView(self.contentView,0)?.topSpaceToView(self.contentView,0)?.bottomSpaceToView(self.contentView,0)?.widthIs(50)
    }
    
    private var newModel = MusicModel()
    var musicModel: MusicModel {
        get {
            return self.newModel
        }
        set {
            self.newModel = newValue
            self.musicIcon.image = self.newModel.artworkImg
            self.musicNameLab.text = self.newModel.musicName
            self.singerAndalbumNamelab.text = "\(self.newModel.singerName)-\(self.newModel.albumName)"
        }
    }
    private var isPlayingSong : Bool = false
    var musicIsPlaying: Bool {
        get {
            return self.isPlayingSong
        }
        set {
            self.isPlayingSong = newValue
            if self.isPlayingSong == true {
                self.musicNameLab.textColor = UIColor.red
                self.singerAndalbumNamelab.textColor = UIColor.red
            }else{
                self.musicNameLab.textColor = UIColor.white
                self.singerAndalbumNamelab.textColor = UIColor.white
            }
        }
    }
    
    @objc func more_item_tap() {
        if (self.tapCallBack != nil) {
            self.tapCallBack!(self.newModel)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
