//
//  SetHomeVC.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class SetHomeVC: BaseVC {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.k_nav_bar.setTitle("?????")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
