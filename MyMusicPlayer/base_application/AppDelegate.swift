//
//  AppDelegate.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        
        
        
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow == nil {
            keyWindow = UIApplication.shared.windows.first
        }
        
        let tab = RootTabBarVC()
        let nav = BaseNAV.init(rootViewController: tab)
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.isTranslucent = false
        nav.isNavigationBarHidden = true
        keyWindow?.rootViewController = nav
        
        
        //告诉系统接受远程响应事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        return true
    }

    // MARK: - app进入后台，退出时保存信息
    func saveAppInfo() {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        saveAppInfo()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveAppInfo()
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        saveAppInfo()
    }

}

