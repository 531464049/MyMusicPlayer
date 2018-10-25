//
//  DirMusicListVC.swift
//  MyMusicPlayer
//
//  Created by 马浩 on 2018/7/13.
//  Copyright © 2018年 马浩. All rights reserved.
//

import UIKit

class DirMusicListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var dirModel = MusicDirModel()
    
    private let dirMusicListIdentifier = "dirMusicListIdentifier"
    private var dataArr = [MusicModel]()
    private var tableview = UITableView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.k_nav_bar.setTitle(self.dirModel.dirName)
        self.k_nav_bar.showBackItem(self, #selector(pop_back))
        commonBuildTableView()
        getDataArr()
    }
    // MARK: - 读取数据
    func getDataArr() {
        MyLoading.showLoading(inVC: self)
        MusicDirHelper.getDirmusicModels(self.dirModel.dirName) { (models) in
            self.dataArr = models
            self.tableview.reloadData()
            MyLoading.stopLoading(inVC: self)
        }
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
        self.tableview.register(DirMusicCell.self, forCellReuseIdentifier: self.dirMusicListIdentifier)
        self.tableview.tableFooterView = UIView()
        self.tableview.fix_iphoneXBottomMargin()
        self.view.addSubview(self.tableview)
        _=self.tableview.sd_layout().leftSpaceToView(self.view,0)?.topSpaceToView(self.k_nav_bar,0)?.rightSpaceToView(self.view,0)?.bottomSpaceToView(self.view,0)
        
    }
    // MARK: - tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DirMusicCell = tableView.dequeueReusableCell(withIdentifier: self.dirMusicListIdentifier, for: indexPath) as! DirMusicCell
        
        cell.musicModel = self.dataArr[indexPath.row]
        
//        if (PlayerHelper.sharedInstance.hasPlayerItem == true && self.dirModel.dirName == PlayerHelper.sharedInstance.dirHelper.dirName && PlayerHelper.sharedInstance.curentMusicName == self.dataArr[indexPath.row]) {
//            cell.musicIsPlaying = true
//        }else{
//            cell.musicIsPlaying = false
//        }
        
//        cell.tapCallBack = {
//            (name:String) -> Void in
//            self.popupMusicInfo(musicName: name)
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let musicModel = self.dataArr[indexPath.row]
//        PlayerHelper.sharedInstance.play(musicName: musicModel.musicName, withDirName: self.dirModel.dirName)
    }
    // MARK: - 弹出歌曲操作界面
    func popupMusicInfo(musicName:String) {
        PopupInfoView.showPopUpInfo(name: musicName) { (selectedType) in
            
        }
    }
    func pop_back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
