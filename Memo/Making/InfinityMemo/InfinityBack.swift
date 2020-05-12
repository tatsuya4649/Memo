//
//  InfinityBack.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension InfinityMemoController{
    public func InfinityBack(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //ページ番号が存在しなかったらページを返さない
        guard let pageViewCounter = pageViewCounter else{return nil}
        //現在のページ番号が0以上のときだけ戻るページを与える
        guard pageViewCounter > 0 else{return nil}
        guard let viewController = viewController as? MakingViewController else {return nil}
        backCheck = Bool(true)
        if nowMakingView != nil{
            nowMakingView.removeCanvas()
        }
        print("現在のメモ番号：\(self.pageViewCounter!)")
        return returnMakingViewController()
    }
    public func backEnd(){
        guard let _ = backCheck else {return}
        //前のページに戻るのでページ番号を1つ減らす
        pageViewCounter -= 1
    }
    ///メイキングビューコントローラの中で現在表示中のページが一番小さければtrueを返す関数
    public func backMinOrNot()->Bool{
        var pageList = Array<Int>()
        if making1.page != nil{
            print("making1.page:\(making1.page)")
            pageList.append(making1.page)
        }
        if making2.page != nil{
            print("making2.page:\(making2.page)")
            pageList.append(making2.page)
        }
        if making3.page != nil{
            print("making3.page:\(making3.page)")
            pageList.append(making3.page)
        }
        if making4.page != nil{
            print("making4.page:\(making4.page)")
            pageList.append(making4.page)
        }
        if making5.page != nil{
            print("making5.page:\(making5.page)")
            pageList.append(making5.page)
        }
        print(pageList)
        print("nowMakingView.page:\(nowMakingView.page)")
        if pageList.min() != nil{
            if pageList.min() == nowMakingView.page{
                return true
            }
        }
        return false
    }
    public func saveBack(_ number:Int){
        let dataSaveView : MakingViewController!
        switch number%5 {
        case 0:
            dataSaveView = making1
        case 1:
            dataSaveView = making2
        case 2:
            dataSaveView = making3
        case 3:
            dataSaveView = making4
        case 4:
            dataSaveView = making5
        default:
            fatalError("pageViewCounterがおかしなことになっていますよ")
        }
        //ビューにしっかり編集・追記などされているかどうかを確認する
        if checkViewEdit(dataSaveView){
            saveData(dataSaveView,number)
        }
        dataSaveView.page = number-5
    }
    ///現在表示中のビューコントローラから1つ前のメモ情報をデータベースから取得する関数
    public func getDataBack(_ number:Int){
        print("1つ前のページ番号\(number)の情報を取得します")
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        fetchReq.predicate = NSPredicate(format:"number=%@",NSNumber(value: Int64(number)))
        do{
            memoDataArray = try? manageContext.fetch(fetchReq) as? Array<Memo>
        }catch{
            print(error)
        }
        print(memoDataArray)
        print("***************************")
        guard memoDataArray.count > 0 else{
            switch number%5 {
            case 0:
                making1.resetView()
            case 1:
                making2.resetView()
            case 2:
                making3.resetView()
            case 3:
                making4.resetView()
            case 4:
                making5.resetView()
            default:
                break
            }
            return
        }
        if let first = memoDataArray.last{
            switch number%5 {
            case 0:
                changeTheData(making1, first)
            case 1:
                changeTheData(making2, first)
            case 2:
                changeTheData(making3, first)
            case 3:
                changeTheData(making4, first)
            case 4:
                changeTheData(making5, first)
            default:
                break
            }
        }
    }
}
