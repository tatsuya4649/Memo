//
//  TabBarController.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TabBarController: UITabBarController,InfinityMemoControllerDelegate {
    func endSaveData() {
        print("データベースへの保存が終了したことを通知します")
        memoList.getData()
    }
    
    var makeInfinity : InfinityMemoController!
    var makeNavi : MakingNavigationController!
    var memoList : MemoListViewController!
    var memoNavi : UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeInfinity = InfinityMemoController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        makeInfinity.saveDelegate = self
        makeNavi = MakingNavigationController(rootViewController: makeInfinity)
        makeNavi.tabBarItem = UITabBarItem(title:"メモ作成", image: UIImage.fontAwesomeIcon(name: .stickyNote, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 0)
        makeNavi.tabBarItem.selectedImage = UIImage.fontAwesomeIcon(name: .stickyNote, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        memoList = MemoListViewController()
        memoNavi = UINavigationController(rootViewController: memoList)
        memoNavi.tabBarItem = UITabBarItem(title: "メモ一覧", image: UIImage.fontAwesomeIcon(name: .listAlt, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 1)
        memoNavi.tabBarItem.selectedImage = UIImage.fontAwesomeIcon(name: .listAlt, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        self.setViewControllers([makeNavi,memoNavi], animated: false)
        self.tabBar.selectedImageTintColor = .black
        self.tabBar.unselectedItemTintColor = .black
        self.selectedIndex = 0
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
