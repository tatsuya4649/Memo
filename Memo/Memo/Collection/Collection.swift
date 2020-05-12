//
//  Collection.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/06.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
//メモ一覧を表示するためのコレクションビューをセッティングするための拡張
extension MemoListViewController:CollectionLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoDataDicArray != nil ? memoDataDicArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if cell.contentView.subviews.count > 0{
            for i in cell.contentView.subviews{
                i.removeFromSuperview()
            }
        }
        if let memoData = memoDataDicArray[indexPath.item] as? Dictionary<MemoDataElement,Any?>{
            cell.setUp(self.view.frame.size.width,memoData)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else{return}
        guard editButtonClickBool == nil else{
            clickEditCell(collectionView,didSelectItemAt: indexPath)
            return
        }
        guard let navi = self.navigationController else{return}
        memoDetailView = MakingViewController()
        if let memoData = memoDataDicArray[indexPath.item] as? Dictionary<MemoDataElement,Any?>{
            memoDetailView.makingDataToApply(memoData)
            //memoDetailView.addHero()
        }
        memoDetailView.addNaviButton()
        memoDetailView.addingGesture(self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0,self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0)
        memoDetailView.detailBool = Bool(true)
        //cell.addHero()
        //navi.hero.isEnabled = true
        navi.pushViewController(memoDetailView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, _ width: CGFloat, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let rate = collectionView.frame.size.height/self.view.frame.size.width
        return rate*width
    }
    
    ///ビューコントローラーを設定する
    public func collectionSetting(){
        collectionViewLayout = CollectionLayout()
        collectionViewLayout.delegate = self
        let height = (self.navigationController != nil ? navigationController!.navigationBar.frame.size.height : 0) + UIApplication.shared.statusBarFrame.size.height
        collectionView = UICollectionView(frame: CGRect(x: 0, y: height, width: self.view.frame.size.width, height: self.view.frame.size.height - (height + (self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0))),collectionViewLayout:collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.isUserInteractionEnabled = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        self.view.addSubview(collectionView)
        
    }
}
