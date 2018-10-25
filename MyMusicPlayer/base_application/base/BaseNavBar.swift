//
//  BaseNavBar.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class BaseNavBar: BaseView {
    var titleLab: UILabel = UILabel()
    var leftBackItem : UIButton?
    var rightItem : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public init(frame: CGRect, title:String) {
        super.init(frame: frame)
        commonInit()
        setTitle(title)
    }
    // MARK: - 初始化
    private func commonInit() {
        self.backgroundColor = UIColor.baseColor()
        commoninitTitleLab()  //初始化标题lab
        let bottomline = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-0.5, width: self.frame.size.width, height: 0.5))
        bottomline.backgroundColor = UIColor.red
        self.addSubview(bottomline)
    }
    // MARK: - 设置标题
    func setTitle(_ title:String) {
        self.titleLab.text = title
    }
    func showBackItem() {
        showBackItem(self, #selector(nav_go_back))
    }
    // MARK: - 返回按钮
    func showBackItem(_ target:Any? , _ action:Selector) {
        if (self.leftBackItem != nil) {
            self.leftBackItem?.removeFromSuperview()
            self.leftBackItem = nil
        }
        self.leftBackItem = UIButton.init(type: .custom)
        self.leftBackItem?.setImage(UIImage.init(named: "common_back"), for: .normal)
        self.leftBackItem?.setImage(UIImage.init(named: "common_back"), for: .highlighted)
        self.leftBackItem?.addTarget(target, action: action, for: .touchUpInside)
        self.addSubview(self.leftBackItem!)
        _=self.leftBackItem?.sd_layout().leftSpaceToView(self,5)?.bottomSpaceToView(self,2)?.heightIs(40)?.widthEqualToHeight()
    }
    // MARK: - 初始化标题lab
    private func commoninitTitleLab() {
        self.titleLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width/3*2, height: NavHeight - K_StatusHeight))
        self.titleLab.center = CGPoint(x: self.frame.size.width/2, y: K_StatusHeight + (NavHeight - K_StatusHeight)/2)
        self.titleLab.textColor = UIColor.red
        self.titleLab.textAlignment = NSTextAlignment.center
        self.titleLab.font = FONT(15)
        self.addSubview(self.titleLab)
    }
    // MARK: - 默认的返回按钮事件
    @objc private func nav_go_back() {
        print("默认的返回按钮事件")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
