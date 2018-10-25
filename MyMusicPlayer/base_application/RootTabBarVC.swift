//
//  RootTabBarVC.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

let KClassStr = "classStr"
let KTitleStr = "classTitle"
let KImgname = "imagename"
let KSelectImg = "sleectedImage"

class RootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let classVCArray = [
                            [KClassStr:"MusicHomeVC",KTitleStr:"音乐",KImgname:"tabbar_01_0",KSelectImg:"tabbar_01"],
                            [KClassStr:"SetHomeVC",KTitleStr:"设置",KImgname:"tabbar_02_0",KSelectImg:"tabbar_02"]]
        
        var vcArr = [UIViewController]()
        
        for item in classVCArray {
            let className = appName() + "." + item[KClassStr]!
            let vcCls = NSClassFromString(className) as! BaseVC.Type
            let vc = vcCls.init()
            vc.title = item[KTitleStr]
            
            let nav = BaseNAV.init(rootViewController: vc)
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.isTranslucent = false
            nav.isNavigationBarHidden = true
            
            let tabbarItem = UITabBarItem.init()
            tabbarItem.title = item[KTitleStr]
            tabbarItem.image = UIImage.init(named: item[KImgname]!)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            tabbarItem.selectedImage = UIImage.init(named: item[KSelectImg]!)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.red,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 9)], for: UIControlState.selected)
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.purple,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 9)], for: UIControlState.normal)
            tabbarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
            
            nav.tabBarItem = tabbarItem
            vcArr.append(nav)
        }
        self.viewControllers = vcArr
        self.tabBar.tintColor = UIColor.white
        self.tabBar.backgroundImage = UIImage.makeImage(UIColor.rgb(22, 9, 11), CGSize(width: kScrWidth, height: TabBarHeight))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
