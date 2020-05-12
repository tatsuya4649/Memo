//
//  MakingViewControllerPEn.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import PencilKit
import FontAwesome_swift

extension MakingViewController:PKCanvasViewDelegate{
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(canvasView.drawing.dataRepresentation())
    }
    ///画面上にペンを出現させる関数
    public func addingPencilTool(){
        if canvas == nil{
            canvas = PKCanvasView(frame:self.view.bounds)
            canvas.backgroundColor = .clear
            canvas.isOpaque = false
            canvas.delegate = self
            self.view.addSubview(canvas)
        }
        if canvasBool == nil{
            if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) {
                canvas.drawingGestureRecognizer.isEnabled = true
                toolPicker.setVisible(true, forFirstResponder: canvas)
                toolPicker.addObserver(canvas)
                canvas.becomeFirstResponder()
            }
            canvasBool = Bool(true)
        }else{
            if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.setVisible(false, forFirstResponder: canvas)
                toolPicker.removeObserver(canvas)
            }
            canvas.drawingGestureRecognizer.isEnabled = false
            canvasBool = nil
        }
        guard let parent = self.parent else{return}
        parent.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .chevronDown, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(closePencil))]
    }
    public func removeCanvas(){
        removePencilTool()
    }
    @objc func closePencil(){
        removePencilTool()
    }
    public func removePencilTool(){
        if canvas != nil{
            canvas.drawingGestureRecognizer.isEnabled = false
            if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.setVisible(false, forFirstResponder: canvas)
                toolPicker.removeObserver(canvas)
            }
        }
        canvasBool = nil
        guard let parent = self.parent else{return}
        if let parent = parent as? InfinityMemoController{
            parent.releaseScroll()
        }
        parent.navigationItem.leftBarButtonItem = nil
    }
    ///キャンバスがなかった場合に、キャンバスを追加するだけの関数
    public func addingCanvas(){
        if canvas == nil{
            canvas = PKCanvasView(frame:self.view.bounds)
            canvas.backgroundColor = .clear
            canvas.isOpaque = false
            canvas.delegate = self
            self.view.addSubview(canvas)
        }
        canvas.drawingGestureRecognizer.isEnabled = false
        canvasBool = nil
    }
    ///データが含まれていた場合にキャンバスを用意する
    public func setUpCanvas(_ data:Data?){
        guard let data = data else{return}
        addingCanvas()
        do{
            canvas.drawing = try PKDrawing(data: data)
        }catch{
            print("データを元にキャンバスに描画をします。")
        }
    }
}
