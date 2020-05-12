//
//  CollectionViewCell.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/06.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import PencilKit
import Hero

class CollectionViewCell: UICollectionViewCell {
    var totalView : UIView!
    var canvas : PKCanvasView!
    var canvasData : Data!
    var textViewData : Data!
    var textView : UITextView!
    var saveDate : Date!
    var number : Int!
    var animation : CABasicAnimation!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUp(_ width:CGFloat,_ memoData:Dictionary<MemoDataElement,Any?>){
        totalView = UIView(frame:CGRect(x: 0, y: 0, width: width, height: width*self.frame.size.height/self.frame.size.width))
        totalView.backgroundColor = .white
        totalView.layer.cornerRadius = 10
        totalView.layer.borderWidth = 1
        totalView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        totalView.clipsToBounds = true
        
        self.contentView.addSubview(totalView)
        if let number = memoData[.number] as? Int64{
            self.number = Int(number)
        }
        if let backgroundColor = memoData[.backgroundColor] as? String{
            if let color = MakingViewController.background(BackgroundColor(name: backgroundColor)!) as? UIColor{
                totalView.backgroundColor = color
            }
        }
        if let canvasData = memoData[.canvas] as? Data{
            self.canvasData = canvasData
            canvas = PKCanvasView(frame: CGRect(x: 0, y: 0, width: totalView.frame.size.width, height: totalView.frame.size.height))
            canvas.drawingGestureRecognizer.isEnabled = false
            canvas.isUserInteractionEnabled = false
            canvas.backgroundColor = .clear
            canvas.isOpaque = false
            totalView.addSubview(canvas)
            do{
                canvas.drawing = try PKDrawing(data: canvasData)
            }catch{
                print("キャンバスデータからキャンバスへの描画に失敗しました")
            }
        }
        if let textData = memoData[.textView] as? Data{
            self.textViewData = textData
            textView = CustomTextView(frame: CGRect(x: 0, y: 0, width: totalView.frame.size.width, height: totalView.frame.size.height))
            textView.backgroundColor = .clear
            textView.isUserInteractionEnabled = false
            do{
                let attributedText = try NSAttributedString(data: textData, options: [.documentType:NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                textView.attributedText = attributedText
            }catch{
                print("テキストデータからテキストビューへの移しに失敗しました")
            }
            totalView.addSubview(textView)
        }
        if let saveDate = memoData[.saveDate] as? Date{
            self.saveDate = saveDate
        }
        totalView.transform = CGAffineTransform(scaleX: self.frame.size.width/width, y: self.frame.size.width/width)
        totalView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    public func addHero(){
        if totalView != nil{
            totalView.hero.id = HeroElement.view.rawValue
        }
        if canvas != nil{
            canvas.hero.id = HeroElement.canvas.rawValue
        }
        if textView != nil{
            textView.hero.id = HeroElement.textView.rawValue
        }
    }
    //セルを未選択状態->選択状態にするためのメソッド
    public func selectCell(){
        self.contentView.alpha = 0.4
    }
    //セルを選択状態->未選択状態にするためのメソッド
    public func unSelectCell(){
        self.contentView.alpha = 1.0
    }
    //セルにアニメーションをかけるためのメソッド
    public func editAnimation(){
        animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = -CGFloat.pi/100
        animation.toValue = CGFloat.pi/100
        animation.duration = 0.2
        animation.repeatCount = .infinity
        animation.autoreverses = true
        self.contentView.layer.add(animation, forKey: "rotation")
        print("セルにアニメーションをかけます")
    }
    //セルにカカっているアニメーションを外すためのメソッド
    public func editRemoveAnimation(){
        self.contentView.layer.removeAllAnimations()
        animation = nil
    }
}
