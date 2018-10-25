//
//  MusicHomeCell.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/10.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class MusicHomeCell: UITableViewCell {
    
    private var icon = UIImageView()
    private var musicNameLab = UILabel()
    private var listCountLab = UILabel()
    private var playIngIcon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectedBackgroundView = UIView.init(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = UIColor.hex(0x3b0336, 1)
        commitSubViews()
    }
    func commitSubViews() {
        
        self.icon = UIImageView.init(frame: CGRect.zero)
        self.icon.contentMode = UIViewContentMode.scaleAspectFill
        self.icon.clipsToBounds = true
        self.contentView.addSubview(self.icon)
        
        self.musicNameLab = UILabel.init(frame: CGRect.zero)
        self.musicNameLab.textColor = UIColor.white
        self.musicNameLab.textAlignment = NSTextAlignment.left
        self.musicNameLab.font = FONT(14)
        self.musicNameLab.numberOfLines = 1
        self.contentView.addSubview(self.musicNameLab)
        
        self.listCountLab = UILabel.init(frame: CGRect.zero)
        self.listCountLab.textColor = UIColor.white
        self.listCountLab.textAlignment = NSTextAlignment.left
        self.listCountLab.font = FONT(14)
        self.listCountLab.numberOfLines = 1
        self.contentView.addSubview(self.listCountLab)
        
        self.playIngIcon = UIImageView.init(frame: CGRect.zero)
        self.playIngIcon.contentMode = UIViewContentMode.scaleAspectFit
        self.playIngIcon.image = UIImage.init(named: "music_dir_isPlaying")
        self.playIngIcon.isHidden = true
        self.playIngIcon.clipsToBounds = true
        self.contentView.addSubview(self.playIngIcon)
        
        _=self.icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.bottomSpaceToView(self.contentView,10)?.widthEqualToHeight()
        _=self.musicNameLab.sd_layout().leftSpaceToView(self.icon,20)?.topSpaceToView(self.contentView,15)?.rightSpaceToView(self.contentView,60)?.autoHeightRatio(0)
        _=self.listCountLab.sd_layout().leftSpaceToView(self.icon,20)?.bottomSpaceToView(self.contentView,15)?.rightSpaceToView(self.contentView,60)?.autoHeightRatio(0)
        _=self.playIngIcon.sd_layout().rightSpaceToView(self.contentView,16)?.centerYEqualToView(self.contentView)?.widthIs(18)?.heightEqualToWidth()
    }
    private var newModel : MusicDirModel? = MusicDirModel()
    var model: MusicDirModel? {
        get {
            return self.newModel
        }
        set {
            self.newModel = newValue
            self.icon.image = self.newModel?.dirIcon
            self.musicNameLab.text = self.newModel?.dirName
            self.listCountLab.text = "\(self.newModel?.musicNum ?? 0)"
            self.playIngIcon.isHidden = !(self.newModel?.isPlayIng)!
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
