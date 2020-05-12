//
//  DeleteCanvasTextForSave.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/04.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController{
    ///メモデータの保存が完了したので、メモキャンバスとテキストを全て新しくします。
    public func saveCanvasTextView(){
        canvasBool = nil
        if canvas != nil{
            canvas.removeFromSuperview()
            canvas = nil
        }
        if textView != nil{
            textView.removeFromSuperview()
            textView = nil
        }
        preTextViewCount = nil
        nowStringAttribute = nil
        font = nil
        textAlign = nil
        underLineType = nil
        strikethroughType = nil
    }
    ///データがなかった時用(メモを取っていなかった時用)でデフォルトにカラーを戻す
    public func resetView(){
        print("resetView")
        print(defaultBackgroundColor)
        self.view.backgroundColor = defaultBackgroundColor != nil ? defaultBackgroundColor : .white
        canvasBool = nil
        if canvas != nil{
            canvas.removeFromSuperview()
            canvas = nil
        }
        if textView != nil{
            textView.removeFromSuperview()
            textView = nil
        }
        preTextViewCount = nil
        nowStringAttribute = nil
        font = nil
        textAlign = nil
        underLineType = nil
        strikethroughType = nil
    }
}
