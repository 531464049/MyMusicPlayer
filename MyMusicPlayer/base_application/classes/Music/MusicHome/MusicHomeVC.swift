//
//  MusicHomeVC.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/3.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class MusicHomeVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    private let MusicHomeListCellIdentifier = "MusicHomeListCellIdentifier"
    private var dataArr = [MusicDirModel]()
    private var tableview = UITableView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tableview.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.k_nav_bar.setTitle("music")
        commonBuildTableView()
        readDataArr()
    }
    // MARK: - 初始化tableview
    func commonBuildTableView() {
        self.tableview = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableview.separatorColor = UIColor.red
        self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableview.backgroundColor = UIColor.baseColor()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.register(MusicHomeCell.self, forCellReuseIdentifier: self.MusicHomeListCellIdentifier)
        self.tableview.tableFooterView = UIView()
        self.tableview.fix_iphoneXBottomMargin()
        self.view.addSubview(self.tableview)
        _=self.tableview.sd_layout().leftSpaceToView(self.view,0)?.topSpaceToView(self.k_nav_bar,0)?.rightSpaceToView(self.view,0)?.bottomSpaceToView(self.view,0)
    }
    // MARK: - 初始化数据源，读取数据
    func readDataArr() {
        let arr = MusicDirHelper.getMusicDirList()
        self.dataArr += arr
        self.tableview.reloadData()
//        MyLoading.showLoading(tips: "正在初始化资源", inVC: self)
//        MusicHelper.updateAllMusicInfo {
//            //结束loading
//            MyLoading.stopLoading(inVC: self)
//            let arr = MusicDirHelper.getMusicDirList()
//            self.dataArr += arr
//            self.tableview.reloadData()
//        }
    }
    // MARK: - tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MusicHomeCell = tableView.dequeueReusableCell(withIdentifier: self.MusicHomeListCellIdentifier, for: indexPath) as! MusicHomeCell
        let model = self.dataArr[indexPath.row]
        model.isPlayIng = false
        if PlayerHelper.sharedInstance.hasPlayerItem == true && model.dirName == PlayerHelper.sharedInstance.dirHelper.dirName {
            model.isPlayIng = true
        }
        cell.model = model
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DirMusicListVC()
        vc.dirModel = self.dataArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
