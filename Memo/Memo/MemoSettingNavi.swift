//
//  File.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/10.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import CoreData

extension MemoListViewController{
    public func settingNaviButton(){
        editButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .done, target: self, action: #selector(clickEdit(_:)))
        self.navigationItem.leftBarButtonItems = [editButton]
    }
    @objc func clickEdit(_ sender:UIBarButtonItem){
        print("編集ボタンがクリックされました")
        if editButtonClickBool == nil{
            //このプロパティがnilじゃないとき全てのセルはクリックされても遷移しない
            editButtonClickBool = Bool(true)
            editButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), style: .done, target: self, action: #selector(clickEdit(_:)))
            self.navigationItem.leftBarButtonItems = [editButton]
            allCellEditAnimation()
            self.title = "編集中"
        }else{
            editButtonClickBool = nil
            editButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .done, target: self, action: #selector(clickEdit(_:)))
            self.navigationItem.leftBarButtonItems = [editButton]
            self.navigationItem.rightBarButtonItems = nil
            allCellUnselect()
            allCellEditRemoveAnimation()
            self.title = "メモ一覧"
        }
        
    }
    ///編集モードのときにセルがクリックされたときの処理をする関数
    public func clickEditCell(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if nowSelectingCellArray == nil{
            nowSelectingCellArray = Array<Int>()
        }
        if nowSelectingCellArray.contains(indexPath.item){
            if let at = nowSelectingCellArray.index(of: indexPath.item){
                nowSelectingCellArray.remove(at: at)
                //セルの選択状態を解除する処理
                guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else{return}
                cell.unSelectCell()
                cell.editAnimation()
            }
        }else{
            nowSelectingCellArray.append(indexPath.item)
            //セルを選択状態にする処理
            guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else{return}
            cell.selectCell()
            cell.editRemoveAnimation()
        }
        checkCellCount()
    }
    private func checkCellCount(){
        if nowSelectingCellArray.count > 0{
            trashButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .trash, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .done, target: self, action: #selector(trashCell))
            self.navigationItem.rightBarButtonItems = [trashButton]
        }else{
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    ///選択されている全てのセルを未選択状態にするためのメソッド
    public func allCellUnselect(){
        guard let nowSelectingCellArray = nowSelectingCellArray else{return}
        guard nowSelectingCellArray.count > 0 else{return}
        for at in nowSelectingCellArray{
            if let cell = collectionView.cellForItem(at: IndexPath(item: at, section: 0)) as? CollectionViewCell{
                cell.unSelectCell()
            }
        }
        self.nowSelectingCellArray.removeAll()
    }
    ///全てのセルに編集中のアニメーションをかけるためのメソッド
    public func allCellEditAnimation(){
        guard let memoDataDicArray = memoDataDicArray else{return}
        guard memoDataDicArray.count > 0 else{return}
        for at in 0..<memoDataDicArray.count{
            if let cell = collectionView.cellForItem(at: IndexPath(item: at, section: 0)) as? CollectionViewCell{
                cell.editAnimation()
            }
        }
    }
    ///全てのセルの編集中のアニメーションを外すためのメソッド
    public func allCellEditRemoveAnimation(){
        guard let memoDataDicArray = memoDataDicArray else{return}
        guard memoDataDicArray.count > 0 else{return}
        for at in 0..<memoDataDicArray.count{
            if let cell = collectionView.cellForItem(at: IndexPath(item: at, section: 0)) as? CollectionViewCell{
                cell.editRemoveAnimation()
            }
        }
    }
    ///セルが1つ以上選択された状態でゴミ箱ボタンがクリックされたときの処理
    @objc func trashCell(sender:UIBarButtonItem){
        print("ゴミ箱ボタンがクリックされたので選択されているセルを削除します。")
        //選択されたセルが1つ以上ある
        guard nowSelectingCellArray.count > 0 else{return}
        print(nowSelectingCellArray)
        
        var indexArray = Array<IndexPath>()
        var memoNumberArray = Array<Int>()
        for at in nowSelectingCellArray{
            if let cell = collectionView.cellForItem(at: IndexPath(item: at, section: 0)) as? CollectionViewCell{
                indexArray.append(IndexPath(item: at, section: 0))
                memoNumberArray.append(cell.number)
            }else{
                print("こっちのやつがあるってことなの？")
            }
        }
        //対応するデータベースのデータを削除するための処理
        deleteData(memoNumberArray)
        collectionView.performBatchUpdates({[weak self] in
            guard let _ = self else{return}
            self!.collectionView.deleteItems(at: indexArray)
            for at in nowSelectingCellArray{
                //セルを削除するので該当のセル番号を選択中セル番号配列の中から削除する
                if let index = nowSelectingCellArray.index(of: at){
                    nowSelectingCellArray.remove(at: index)
                    memoDataDicArray.remove(at: index)
                    checkCellCount()
                }
            }
            print("無事コレクションビューから特定のセルを削除することに成功しました")
        }, completion: nil)
        
    }
}
