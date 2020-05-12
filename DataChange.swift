//
//  DataChange.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/05.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import PencilKit

extension InfinityMemoController{
    ///データベースに保存されているデータを取り出し整理してviewの復元までする
    public func changeTheData(_ view:MakingViewController,_ memo:Memo){
        if let backgroundColor = memo.backgroudColor{
            view.viewBackgroundColor = BackgroundColor(name: backgroundColor)
            view.backgroundApply(BackgroundColor(name: backgroundColor)!)
        }else{
            view.view.backgroundColor = view.defaultBackgroundColor != nil ? view.defaultBackgroundColor : .orange
        }
        if let canvasData = memo.canvas as? Data{
            view.addingCanvas()
            do{
                view.canvas.drawing = try PKDrawing(data: canvasData)
            }catch{
                print("データからキャンバスへの描画に失敗しました")
            }
        }
        if let textData = memo.textView as? Data{
            view.dataToText(textData)
        }
    }
}
