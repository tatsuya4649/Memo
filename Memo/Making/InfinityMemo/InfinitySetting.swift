//
//  InfinitySetting.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//メモのセッティングに関する拡張
extension InfinityMemoController{
    //ナビゲーション・タブバーの高さを考慮したビューコントローラーを返す
    func returnMakingViewController()-> MakingViewController{
        if let _ = backCheck as? Bool{
            switch (pageViewCounter)%5 {
            case 0:
                return making5
            case 1:
                return making1
            case 2:
                return making2
            case 3:
                return making3
            case 4:
                return making4
            default:
                fatalError("pageViewCounterがおかしなことになっていますよ")
            }
        }else{
            switch pageViewCounter%5 {
            case 0:
                return making2
            case 1:
                return making3
            case 2:
                return making4
            case 3:
                return making5
            case 4:
                return making1
            default:
                fatalError("pageViewCounterがおかしなことになっていますよ")
            }
        }
    }
    //何もしていないメモを削除していく
    public func memoSetting(){
        print("現在のpageViewCounterのカウントは:\(pageViewCounter)")
        switch pageViewCounter%5 {
        case 0:
            nowMakingView = making1
        case 1:
            nowMakingView = making2
        case 2:
            nowMakingView = making3
        case 3:
            nowMakingView = making4
        case 4:
            nowMakingView = making5
        default:
            fatalError("pageViewCounterがおかしなことになっていますよ")
        }
        nowMakingView.page = pageViewCounter
    }
    public func dataCheck(){
        print("dataCheck~~~")
        print(pageViewCounter)
        print(forwardCheck)
        //進みおわったときの処理
        if forwardCheck != nil{
            forwardCheck = nil
            guard pageViewCounter >= 4 else{return}
            print("メモ番号が4以上")
            guard forwardMaxOrNot() else{return}
            print("ビューコントローラの中で現在が一番大きなページ番号です")
            saveForward(pageViewCounter-4)
            getDataForward(pageViewCounter+1)
            //戻りおわったときの処理
        }else{
            backCheck = nil
            guard checkMaxFromNow() >= 3 else{return}
            print("最大から3以上大きくなりました〜〜〜")
            guard backMinOrNot() else{return}
            print("ビューコントローラの中で現在が一番小さなページ番号です")
            guard pageViewCounter - 1 >= 0 else{return}
            print("1つ前のページ番号は1以上です")
            saveBack(pageViewCounter+4)
            getDataBack(pageViewCounter-1)
            print(making2.canvas)
        }
    }
    public func checkMaxPage(){
        if maxPageViewCounter == nil{
            maxPageViewCounter = Int(0)
        }
        if maxPageViewCounter < pageViewCounter{
            maxPageViewCounter = pageViewCounter
        }
    print("メモの最大ページ数は\(maxPageViewCounter)ページです。")
    }
    
    public func checkMaxFromNow()->Int{
        guard let maxPageViewCounter = maxPageViewCounter else {return 0}
        return maxPageViewCounter - pageViewCounter
    }
    ///指定されたビューに追記されているかどうかを取得する
    public func checkViewEdit(_ dataSaveView:MakingViewController)->Bool{
        //キャンバス内に描いているサイズが0でテキストビューのテキスト数が0だったらfalse、それ以外だったらtrue
        if dataSaveView.canvas != nil{
            if dataSaveView.canvas.drawing.bounds.size != .zero{
                print("キャンバスに何か書いてあったのでデータベースにデータを保存します。")
                return true
            }
        }
        if dataSaveView.textView != nil{
            if dataSaveView.textView.text.count != 0{
                print("テキストビューに何か書いてあったのでデータベースにデータを保存します。")
                return true
            }
        }
        print("何もメモしていないので、データを保存しません")
        return false
    }
    
    
}
