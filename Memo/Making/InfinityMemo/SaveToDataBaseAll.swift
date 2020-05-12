//
//  SaveToDataBaseAll.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/06.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData

///メモされている全てのメモをデータベースに保存するための拡張
extension InfinityMemoController{
    ///
    public func memoAllSave(completion:(()->Void)?){
        let start = Date()
        print("memoDataArray.count")
        print(making1.page)
        print(making2.page)
        print(making3.page)
        print(making4.page)
        print(making5.page)
        
        //let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        
        if checkViewEdit(making1){
            print("making1:\(making1.page ?? nil)が編集されていました。")
            guard let number = making1.page else{return}
            saveData(making1,number)
        }else{
            print("making1:\(making1.page ?? nil)は何も編集されていませんでした。")
        }
        self.memoDataArray = Array<Memo>()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            self.memoDataArray = try? self.manageContext.fetch(request) as? Array<Memo>
        }
        print("おいっす〜〜〜")
        for i in memoDataArray{
            print(i.number)
        }
        if checkViewEdit(making2){
            print("making2:\(making2.page ?? nil)が編集されていました。")
            guard let number = making2.page else{return}
            saveData(making2,number)
        }else{
            print("making2:\(making2.page ?? nil)は何も編集されていませんでした")
        }
        self.memoDataArray = Array<Memo>()
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            self.memoDataArray = try? self.manageContext.fetch(request) as? Array<Memo>
        }
        print("おいっす〜〜〜")
        for i in memoDataArray{
            print(i.number)
        }
        if checkViewEdit(making3){
            print("making3:\(making3.page ?? nil)が編集されていました。")
            guard let number = making3.page else{return}
            saveData(making3,number)
        }else{
            print("making3:\(making3.page ?? nil)が編集されていました。")
        }
        self.memoDataArray = Array<Memo>()
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            self.memoDataArray = try? self.manageContext.fetch(request) as? Array<Memo>
        }
        print("おいっす〜〜〜")
        for i in memoDataArray{
            print(i.number)
        }
        if checkViewEdit(making4){
            print("making4:\(making4.page ?? nil)が編集されていました。")
            guard let number = making4.page else{return}
            saveData(making4,number)
        }else{
            print("making4:\(making4.page ?? nil)が編集されていませんでした。")
        }
        self.memoDataArray = Array<Memo>()
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            self.memoDataArray = try? self.manageContext.fetch(request) as? Array<Memo>
        }
        print("おいっす〜〜〜")
        for i in memoDataArray{
            print(i.number)
        }
        if checkViewEdit(making5){
            print("making5:\(making5.page ?? nil)が編集されていました。")
            guard let number = making5.page else{return}
            saveData(making5,number)
        }else{
            print("making5:\(making5.page ?? nil)が編集されていませんでした。")
        }
        self.memoDataArray = Array<Memo>()
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            self.memoDataArray = try? self.manageContext.fetch(request) as? Array<Memo>
        }
        print("おいっす〜〜〜")
        for i in memoDataArray{
            print(i.number)
        }
        let end = Date().timeIntervalSince(start)
        print("データベースへの保存にかかった時間:\(end)s")
        completion?()
    }
}
