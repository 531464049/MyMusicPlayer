//
//  BaseVC.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

@objcMembers
class BaseVC: UIViewController , UIGestureRecognizerDelegate {

    var k_nav_bar : BaseNavBar = BaseNavBar()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        MyLoading.stopLoading()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.baseColor()
        //设置CGRectZero从导航栏下开始计算
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        //初始化导航栏,所有继承的vc都默认存在该导航栏
        commonInitNavBar()
    }
    func commonInitNavBar() {
        self.k_nav_bar = BaseNavBar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: NavHeight), title: "")
        self.view.addSubview(self.k_nav_bar)
    }
    override func remoteControlReceived(with event: UIEvent?) {
        print("远程控制-点击")
        if (event == nil || event?.type != UIEventType.remoteControl) {
            return
        }
        
        switch event!.subtype {
        case UIEventSubtype.remoteControlPlay:
            print("播放")
            PlayerHelper.sharedInstance.playOrPause()
            break
        case UIEventSubtype.remoteControlPause:
            print("暂停")
            PlayerHelper.sharedInstance.playOrPause()
            break
        case UIEventSubtype.remoteControlNextTrack:
            print("下一首")
            PlayerHelper.sharedInstance.playNextSong()
            break
        case UIEventSubtype.remoteControlPreviousTrack:
            print("上一首")
            PlayerHelper.sharedInstance.playPreviousSong()
            break
        case UIEventSubtype.remoteControlTogglePlayPause:
            print("暂停/播放")
            PlayerHelper.sharedInstance.playOrPause()
            break
        default:
            break
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var shouldAutorotate: Bool {
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
