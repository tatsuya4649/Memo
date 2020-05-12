//
//  GettingMemoFromDataBase.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/06.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum MemoDataElement{
    case backgroundColor
    case canvas
    case number
    case saveDate
    case textView
}

extension MemoListViewController{
    ///データベースから保存中のデータを全て取得する
    public func getDataFromDataBase(){
        let start = Date()
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            memoDataArray = try? manageContext.fetch(request) as? Array<Memo>
        }catch{
            print("データベースからのデータの取得に失敗しました")
        }
        let end = Date().timeIntervalSince(start)
        print("データベースから全てのデータを取得するのにかかった時間:\(end)s")
        dataOrganization()
    }
    ///データの数が1つ以上あったときの処理
    public func dataOrganization(){
        guard let memoDataArray = memoDataArray else{return}
        guard memoDataArray.count > 0 else{return}
        memoDataDicArray = Array<Dictionary<MemoDataElement,Any?>>()
        for memoData in memoDataArray{
            var dic = Dictionary<MemoDataElement,Any?>()
            dic = [
                .backgroundColor:memoData.backgroudColor != nil ? memoData.backgroudColor : nil,
                .canvas:memoData.canvas != nil ? memoData.canvas : nil,
                .number:memoData.number != nil ? memoData.number : nil,
                .saveDate:memoData.saveDate != nil ? memoData.saveDate : nil,
                .textView:memoData.textView != nil ? memoData.textView : nil
            ]
            print(dic[.number])
            guard checkTheSameNumber(dic) else{return}
        }
    }
    ///同じデータがあった場合に早い方を削除するためのメソッド
    private func checkTheSameNumber(_ dic:Dictionary<MemoDataElement,Any?>)->Bool{
        guard let number = dic[.number] as? Int64 else{return false}
        guard let memoDate = dic[.saveDate] as? Date else{return false}
        var bool = Bool(true)
        //すでに追加されているデータの中身から1つずつ取り出す
        for at in 0..<memoDataDicArray.count{
            if let dataNumber = memoDataDicArray[at][.number] as? Int64{
                //もしも同じメモ番号のデータがあった場合・・・
                if dataNumber == number{
                    if let dateDate = memoDataDicArray[at][.saveDate] as? Date{
                        //今から追加しようとしているデータが、すでに追加されているデータよりも古い場合は、追加しない(falseを返す)
                        if memoDate < dateDate{
                            bool = Bool(false)
                        }else{
                            //追加しようとしているデータの方が新しい場合は、すでに追加されているデータを削除してから追加する(データ被りをなくすため)
                            memoDataDicArray.remove(at: at)
                        }
                    }
                }
            }
        }
        if bool{
            memoDataDicArray.append(dic)
        }
        return true
    }
    public func dataNumberSort(){
        guard let _ = memoDataDicArray else{return}
        guard memoDataDicArray.count > 0 else{return}
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
    ///まとめて削除するために必要なメモ番号配列を引数に受け取り削除を行う
    ///ここで更にメモ番号の整理整頓のも同時に行う
    public func deleteData(_ memoNumberArray:Array<Int>){
        //特定のメモ番号よりも大きい番号を全て1つ繰り下げる
        memoDataArray = Array<Memo>()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            memoDataArray = try? manageContext.fetch(request) as? Array<Memo>
            if memoDataArray.count > 0{
                //Step.1 引数で受け取ったメモ番号を元に全て削除していく
                guard memoNumberArray.count > 0 else{return}
                for i in memoNumberArray{
                    let array = memoDataArray.filter { $0.number == Int64(i) }
                    if array.count > 0{
                        for i in array{
                            manageContext.delete(i)
                            if let i = memoDataArray.index(of: i){
                                memoDataArray.remove(at: i)
                            }
                        }
                    }
                }
                print(memoNumberArray)
                //Step.2 引数で受け取ったメモ番号を元に
                for data in memoDataArray{
                    //データベースのデータのメモ番号を1つずつ取り出す
                    if var number =  data.number as? Int64{
                        print(number)
                        //numberが削除した番号じゃなかったときのみ発動させる
                        if memoNumberArray.contains(Int(number)) == false{
                            //引数の配列の中の最小値よりも値が大きいときにだけ発動
                            if number > Int64(memoNumberArray.min()!){
                                //number += Int64(i)
                                //1つずつ引数の値を取り出して・・・
                                for i in 0..<memoNumberArray.count{
                                    var newNumberArray = memoNumberArray
                                    newNumberArray.append(Int(number))
                                    newNumberArray.sort{ $0 < $1 }
                                    if let index = newNumberArray.index(of: Int(number)){
                                        print("\(number)を\(index)だけ小さくします")
                                        //インデックスの順番と同じだけメモ番号を小さくする(前に詰める)
                                        data.number -= Int64(index)
                                        newNumberArray.remove(at: index)
                                    }
                                }
                            }
                        }
                        //for i in 0..<memoNumberArray.count{
                            
                        //}
                    }
                }
                //for i in memoDataArray{
                    
                    //if let dataNumber =  i.number as? Int64{
                        //if memoNumberArray.contains(Int(dataNumber)){
                            //if let index = memoNumberArray.index(of: Int(dataNumber)){
                                //if dataNumber == memoNumberArray[index]{
                                    //print("メモ番号\(dataNumber)を削除します")
                                    //manageContext.delete(i)
                                //}
                            //}
                        //}
                        
                    //}
                //}
            }
            do{
                try manageContext.save()
            }catch{
                print("セーブに失敗しました")
            }
        }catch{
            print(error)
        }
        do{
            memoDataArray = try? manageContext.fetch(request) as? Array<Memo>
        }catch{
            print("データベースからのデータの取得に失敗しました")
        }
        for i in memoDataArray{
            print(i.number)
        }
    }
}
