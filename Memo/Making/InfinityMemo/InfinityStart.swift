//
//  InfinityStart].swift
//  Memo
//
//  Created by 下川達也 on 2020/05/08.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension InfinityMemoController{
    ///データベースから全てのデータを取得する関数
    public func getAllData(){
        let start = Date()
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            memoDataArray = try? manageContext.fetch(request) as? Array<Memo>
        }catch{
            print("データベースからのデータの取得に失敗しました")
        }
        let end = Date().timeIntervalSince(start)
        print("データベースから全てのデータを取得するのにかかった時間:\(end)s")
        print(memoDataArray)
        
        dataOrganization()
    }
    ///データの数が1つ以上あったときの処理
    public func dataOrganization(){
        guard let memoDataArray = memoDataArray else{return}
        guard memoDataArray.count > 0 else{return}
        memoDataDicArray = Array<Dictionary<MemoDataElement,Any?>>()
        var preNumber : Int64!
        print(memoDataArray.count)
        print("***********")
        for memoData in memoDataArray{
            var dic = Dictionary<MemoDataElement,Any?>()
            if var number =  memoData.number as? Int64{
                //var int = Int64(0)
                //while((preNumber+1) != (number-int)){
                    //int += 1
                //}
                if preNumber == nil{
                    number = 0
                }else{
                    number = preNumber + 1
                }
                print(number)
                print(preNumber)
                dic = [
                    .backgroundColor:memoData.backgroudColor != nil ? memoData.backgroudColor : nil,
                    .canvas:memoData.canvas != nil ? memoData.canvas : nil,
                    .number:number,
                    .saveDate:memoData.saveDate != nil ? memoData.saveDate : nil,
                    .textView:memoData.textView != nil ? memoData.textView : nil
                ]
                if checkTheSameNumber(dic){
                    memoDataDicArray.append(dic)
                }
                preNumber = number
            }
        }
        do{
            try manageContext.save()
        }catch{
            print("セーブに失敗しました")
        }
        //始まりは、いつも新しいページからにする
        pageViewCounter = memoDataDicArray.count
        maxPageViewCounter = pageViewCounter
        viewMemoSetting()
    }
    ///同じデータがあった場合に早い方を削除するためのメソッド
    private func checkTheSameNumber(_ dic:Dictionary<MemoDataElement,Any?>)->Bool{
        guard let number = dic[.number] as? Int64 else{return false}
        guard let memoDate = dic[.saveDate] as? Date else{return false}
        //すでに追加されているデータの中身から1つずつ取り出す
        for at in 0..<memoDataDicArray.count{
            if let dataNumber = memoDataDicArray[at][.number] as? Int64{
                //もしも同じメモ番号のデータがあった場合・・・
                if dataNumber == number{
                    if let dateDate = memoDataDicArray[at][.saveDate] as? Date{
                        //今から追加しようとしているデータが、すでに追加されているデータよりも古い場合は、追加しない(falseを返す)
                        if memoDate < dateDate{
                            return false
                        }else{
                            //追加しようとしているデータの方が新しい場合は、すでに追加されているデータを削除してから追加する(データ被りをなくすため)
                            memoDataDicArray.remove(at: at)
                            return true
                        }
                    }
                }
            }
        }
        return true
    }
    ///データベースに保存されているデータを元にビューに適用していく
    private func viewMemoSetting(){
        guard let pageViewCounter = pageViewCounter else{return}
        print("保存してあるメモナンバーは？")
        for data in memoDataDicArray{
            print(data[.number])
        }
        dataNumberSort()
        print("順番を正しく入れ替えます")
        for data in memoDataDicArray{
            print(data[.number])
        }
        print("viewMemoSetting")
        print(pageViewCounter%5)
        switch pageViewCounter%5 {
        case 0:
            ///データを適用するのはmaking4,making3,making2(新しい順)
            if memoDataDicArray.count >= 1 {
                setViewControllers([making1], direction: .forward, animated: false, completion: nil)
                if let data = memoDataDicArray[memoDataDicArray.count - 1] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making5,data)
                    making5.page = pageViewCounter - 1
                }
            }
            
            if memoDataDicArray.count >= 2 {
                if let data = memoDataDicArray[memoDataDicArray.count - 2] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making4,data)
                    making4.page = pageViewCounter - 2
                }
            }
            
            if memoDataDicArray.count >= 3 {
                if let data = memoDataDicArray[memoDataDicArray.count - 3] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making3,data)
                    making3.page = pageViewCounter - 3
                }
            }
            
            if memoDataDicArray.count > 3 {
                making2.page = pageViewCounter + 1
            }
            
        case 1:
            ///データを適用するのはmaking5,making4,making3(新しい順)
            if memoDataDicArray.count >= 1 {
                setViewControllers([making2], direction: .forward, animated: false, completion: nil)
                if let data = memoDataDicArray[memoDataDicArray.count - 1] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making1,data)
                    making1.page = pageViewCounter - 1
                }
            }
            
            if memoDataDicArray.count >= 2 {
                if let data = memoDataDicArray[memoDataDicArray.count - 2] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making5,data)
                    making5.page = pageViewCounter - 2
                }
            }
            
            if memoDataDicArray.count >= 3 {
                if let data = memoDataDicArray[memoDataDicArray.count - 3] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making4,data)
                    making4.page = pageViewCounter - 3
                }
            }
            
            if memoDataDicArray.count > 3 {
                making3.page = pageViewCounter + 1
            }
            
        case 2:
            ///データを適用するのはmaking1,making5,making4(新しい順)
            if memoDataDicArray.count >= 1 {
                setViewControllers([making3], direction: .forward, animated: false, completion: nil)
                if let data = memoDataDicArray[memoDataDicArray.count - 1] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making2,data)
                    making2.page = pageViewCounter - 1
                }
            }
            
            if memoDataDicArray.count >= 2 {
                if let data = memoDataDicArray[memoDataDicArray.count - 2] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making1,data)
                    making1.page = pageViewCounter - 2
                }
            }
            
            if memoDataDicArray.count >= 3 {
                if let data = memoDataDicArray[memoDataDicArray.count - 3] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making5,data)
                    making5.page = pageViewCounter - 3
                }
            }
            if memoDataDicArray.count > 3 {
                making4.page = pageViewCounter + 1
            }
            
        case 3:
            ///データを適用するのはmaking2,making1,making5(新しい順)
            if memoDataDicArray.count >= 1 {
                setViewControllers([making4], direction: .forward, animated: false, completion: nil)
                if let data = memoDataDicArray[memoDataDicArray.count - 1] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making3,data)
                    making3.page = pageViewCounter - 1
                }
            }
            
            if memoDataDicArray.count >= 2 {
                if let data = memoDataDicArray[memoDataDicArray.count - 2] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making2,data)
                    making2.page = pageViewCounter - 2
                }
            }
            
            if memoDataDicArray.count >= 3 {
                if let data = memoDataDicArray[memoDataDicArray.count - 3] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making1,data)
                    making1.page = pageViewCounter - 3
                }
            }
            if memoDataDicArray.count > 3 {
                making5.page = pageViewCounter + 1
            }
            
        case 4:
            print("生理痛")
            ///データを適用するのはmaking3,making2,making1
            if memoDataDicArray.count >= 1 {
                setViewControllers([making5], direction: .forward, animated: false, completion: nil)
                if let data = memoDataDicArray[memoDataDicArray.count - 1] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making4,data)
                    making4.page = pageViewCounter - 1
                    print(making4.page)
                }
            }
            if memoDataDicArray.count >= 2 {
                if let data = memoDataDicArray[memoDataDicArray.count - 2] as? Dictionary<MemoDataElement,Any?>{
                    viewApply(making3,data)
                    making3.page = pageViewCounter - 2
                    print(making3.page)
                }
            }
            if memoDataDicArray.count >= 3 {
                if let data = memoDataDicArray[memoDataDicArray.count - 3] as? Dictionary<MemoDataElement,Any?>{
                        viewApply(making2,data)
                        making2.page = pageViewCounter - 3
                    print(making2.page)
                    }
            }
            if memoDataDicArray.count > 3 {
                making1.page = pageViewCounter + 1
                print(making1.page)
            }
            
        default:break
        }
        self.pageViewCounter = memoDataDicArray.count
        maxPageViewCounter = pageViewCounter
        memoSetting()
    }
    ///番号順に入れ替える関数
    private func dataNumberSort(){
        guard let _ = memoDataDicArray else{return}
        for i in 0..<memoDataDicArray.count-1{
            for j in i+1..<memoDataDicArray.count{
                if let iNumber = memoDataDicArray[i][.number] as? Int64{
                    if let jNumber = memoDataDicArray[j][.number] as? Int64{
                        if jNumber < iNumber{
                            let temp = memoDataDicArray[i]
                            memoDataDicArray[i] = memoDataDicArray[j]
                            memoDataDicArray[j] = temp
                        }
                    }
                }
            }
        }
    }
    private func viewApply(_ view:MakingViewController,_ data:Dictionary<MemoDataElement,Any?>){
        view.makingDataToApply(data)
    }
}
