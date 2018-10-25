//
//  UITableViewExtension.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/10.
//  Copyright © 2018年 马浩. All rights reserved.
//

import Foundation

extension UITableView {
    func fix_iphoneXBottomMargin() {
        if k_is_iphoneX() {
            let insets = self.contentInset
            self.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + k_bottom_margin, insets.right)
        }
    }
}
