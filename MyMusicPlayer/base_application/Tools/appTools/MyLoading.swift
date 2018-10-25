//
//  MyLoading.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/17.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

private struct MyLoadingUX {
    static let loadingHeight : CGFloat = 50.0    //loading区域需要的高度
    static let normalWidth : CGFloat = kScrWidth/2         //默认宽度
    static let maxWidth : CGFloat = kScrWidth - 90         //最大宽度
    static let tipFont = UIFont.systemFont(ofSize: 14)    //tip字体大小
    static let tipColor = UIColor.red             //tip颜色
    static let tipLineSpace : CGFloat = 5.0                  //tip行间距
    static let tipNormalHeight : CGFloat = 20.0             //tip最小（默认高度）
    static let tipSpaceMargin : CGFloat = 10.0              //tip左右间隔
}

class MyLoading: UIView {
    
    var activity : UIActivityIndicatorView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    private func buildLoading(tips:String?,loading:Bool) {
        // 计算宽高
        var width = MyLoadingUX.normalWidth
        var height : CGFloat = 0.0
        if loading == true {
            height += MyLoadingUX.loadingHeight //默认的loading区域占80高度
        }
        if tips != nil && tips!.count > 0 {
            // 计算 单独一行显示tip所需要的宽度
            let singLineWidth = tips!.getWidth(labHeight: 16, font: MyLoadingUX.tipFont, lineSpace: MyLoadingUX.tipLineSpace, keming: 0)
            if (singLineWidth <= MyLoadingUX.maxWidth-2*MyLoadingUX.tipSpaceMargin) {
                //单独一行就可以完全显示
                width = singLineWidth + 2*MyLoadingUX.tipSpaceMargin
                height += (MyLoadingUX.tipNormalHeight + MyLoadingUX.tipSpaceMargin * 2)
            }else{
                //计算在最大宽度下所需高度
                let tipStrHeight = tips!.getHeight(labWidth: MyLoadingUX.maxWidth - 2*MyLoadingUX.tipSpaceMargin, font: MyLoadingUX.tipFont, lineSpace: MyLoadingUX.tipLineSpace, keming: 0)
                if tipStrHeight > MyLoadingUX.tipNormalHeight {
                    width = MyLoadingUX.maxWidth
                    height += (tipStrHeight + MyLoadingUX.tipSpaceMargin * 2)
                }else{
                    width = MyLoadingUX.maxWidth
                    height += (MyLoadingUX.tipNormalHeight + MyLoadingUX.tipSpaceMargin * 2)
                }
            }
        }
        if height > self.frame.size.height-120 {
            height = self.frame.size.height-120
        }
        
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        contentView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        contentView.backgroundColor = UIColor.orange
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        self.addSubview(contentView)
        
        if loading == true {
            self.activity = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            self.activity?.center = CGPoint(x: width/2, y: MyLoadingUX.loadingHeight/2)
            self.activity?.color = UIColor.red
            contentView.addSubview(self.activity!)
            self.activity?.startAnimating()
        }
        if tips != nil && tips!.count > 0 {
            var ory = MyLoadingUX.tipSpaceMargin
            if loading == true {
                ory = MyLoadingUX.tipSpaceMargin + MyLoadingUX.loadingHeight
            }
            let tipLab = UILabel.init(frame: CGRect(x: MyLoadingUX.tipSpaceMargin, y: ory, width: width-2*MyLoadingUX.tipSpaceMargin, height: height-ory-MyLoadingUX.tipSpaceMargin))
            tipLab.numberOfLines = 0
            tipLab.attributedText = tips!.toAttributeStr(font: MyLoadingUX.tipFont, color: UIColor.red, aligent: NSTextAlignment.center, lineSpace: MyLoadingUX.tipLineSpace, keming: 0)
            contentView.addSubview(tipLab)
            
        }
    }
    
    
    class func showLoading(inVC:BaseVC) {
        MyLoading.show(tips: nil, loading: true,inVC: inVC)
    }
    class func showLoading(tips:String?,inVC:BaseVC) {
        MyLoading.show(tips: tips, loading: true,inVC: inVC)
    }
    class func showTips(tips:String?,inVC:BaseVC) {
        MyLoading.show(tips: tips, loading: false,inVC: inVC)
    }
    class private func show(tips:String?,loading:Bool,inVC:BaseVC) {
        MyLoading.stopLoading(inVC: inVC)
        
        var ory : CGFloat = 0
        if inVC.k_nav_bar.isHidden == false {
            ory = NavHeight
        }
        let loadingView = MyLoading.init(frame: CGRect(x: 0, y: ory, width: kScrWidth, height: inVC.view.frame.size.height-ory-TabBarHeight-k_bottom_margin))
        loadingView.buildLoading(tips: tips, loading: loading)
        inVC.view.addSubview(loadingView)
    }
    class func stopLoading(inVC:BaseVC) {
        for subView in inVC.view.subviews {
            if subView.isKind(of: MyLoading.self) {
                UIView.animate(withDuration: 0.3, animations: {
                    subView.alpha = 0.0
                }) { (finished) in
                    subView.removeFromSuperview()
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
