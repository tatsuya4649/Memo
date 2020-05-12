//
//  InfinityForward.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData

///次に進むために関する拡張
extension InfinityMemoController{
    public func InfinityForward(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //ページ番号が存在しなかったらページを返さない
        guard let _ = pageViewCounter else{return nil}
        guard let viewController = viewController as? MakingViewController else {return nil}
        self.forwardCheck = Bool(true)
        print("現在のメモ番号：\(self.pageViewCounter!)")
        if nowMakingView != nil{
            nowMakingView.removeCanvas()
        }
        return returnMakingViewController()
    }
    public func forwardEnd(){
        guard let _ = forwardCheck else {return}
        //次のページ番号に進むためページ番号を1つ増やす
        pageViewCounter += 1
    }
    ///メイキングビューコントローラの中で、現在表示しているメイキングのページ番号が一番大きければtrueを返す
    public func forwardMaxOrNot()->Bool{
        var pageList = Array<Int>()
        if making1.page != nil{
            pageList.append(making1.page)
        }
        if making2.page != nil{
            pageList.append(making2.page)
        }
        if making3.page != nil{
            pageList.append(making3.page)
        }
        if making4.page != nil{
            pageList.append(making4.page)
        }
        if making5.page != nil{
            pageList.append(making5.page)
        }
        if pageList.max() != nil{
            if pageList.max() == nowMakingView.page{
                return true
            }
        }
        return false
    }
    public func saveForward(_ number:Int){
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
        dataSaveView.page = number+5
    }
    ///現在表示中のビューコントローラから1つ後のメモ情報をデータベースから取得する関数
    public func getDataForward(_ number:Int){
        print("次のページ番号\(number)の情報を取得します")
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
