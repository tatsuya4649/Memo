//
//  DetailMemoGesture.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/09.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController{
    ///メモの詳細ページでテキストやキャンバスの編集ができるようにジェスチャーを追加する
    public func addingGesture(_ naviHeight:CGFloat,_ tabHeight:CGFloat){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
        longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longTapGesture)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.view.frame = CGRect(x: 0, y: statusBarHeight + naviHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - (statusBarHeight + naviHeight + tabHeight))
        print(self.view.frame)
        
        addBackgroundSettingButton()
        if canvas != nil{
            canvas.frame = self.view.bounds
        }
        if textView != nil{
            textView.frame = self.view.frame
        }
    }
    @objc func doubleTap(_ sender:UISwipeGestureRecognizer){
        self.addingPencilTool()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .chevronDown, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(closePencilDetail))]
        closeBackgroundSetting()
    }
    ///背景色を変更させるスクロールビューを閉じる
    public func closeBackgroundSetting(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {[weak self] in
            guard let _ = self else{return}
            self!.backgroundScrollView.transform = CGAffineTransform(translationX: 0, y: self!.backgroundScrollView.frame.size.height)
        }, completion: nil)
    }
    ///閉じてある背景色を変更させるスクロールビューを開く
    public func openBackgroundSetting(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {[weak self] in
            guard let _ = self else{return}
            self!.backgroundScrollView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        
    }
    @objc func closePencilDetail(_ sender:UIBarButtonItem){
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.hidesBackButton = false
        removePencilTool()
        openBackgroundSetting()
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .chevronDown, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(closeTextViewDetail(_:)))]
        self.addTextView()
    }
    @objc func closeTextViewDetail(_ sender:UIBarButtonItem){
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.hidesBackButton = false
        textView.isEditable = false
        textView.resignFirstResponder()
    }
    private func addBackgroundSettingButton(){
        guard backgroundVisualEffect == nil else{return}
        backgroundVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundVisualEffect.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50)
        backgroundScrollView = UIScrollView(frame:CGRect(x: 0, y: self.view.frame.maxY - 50, width: self.view.bounds.size.width, height: 50))
        backgroundScrollView.isPagingEnabled = true
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.contentSize = CGSize(width: backgroundScrollView.frame.size.width*2, height: backgroundScrollView.frame.size.height)
        self.backgroundScrollView.addSubview(backgroundVisualEffect)
        self.view.addSubview(backgroundScrollView)
        addBackgroundChangeButton()
    }
    private func addBackgroundChangeButton(){
        for i in 0...10{
            let backgroundButton = UIButton()
            backgroundButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            backgroundButton.backgroundColor = .white
            backgroundButton.layer.cornerRadius = backgroundButton.frame.size.height/2
            backgroundButton.layer.shadowColor = UIColor.black.cgColor
            backgroundButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            backgroundButton.layer.shadowOpacity = 0.1
            backgroundButton.layer.shadowRadius = 2
            backgroundButton.addTarget(self, action: #selector(backgroundColorChange), for: .touchUpInside)
            let backgroundButtonLayer = CALayer()
            backgroundButtonLayer.bounds = CGRect(x: 0, y: 0, width: backgroundButton.frame.size.width*0.8, height: backgroundButton.frame.size.height*0.8)
            backgroundButtonLayer.position = CGPoint(x: backgroundButton.frame.size.width/2, y: backgroundButton.frame.size.height/2)
            backgroundButtonLayer.cornerRadius = backgroundButtonLayer.bounds.height/2
            backgroundButton.layer.addSublayer(backgroundButtonLayer)
            backgroundScrollView.addSubview(numberButtonAddColor(BackgroundColor(rawValue: i)!,backgroundButton))
        }
    }
    private func numberButtonAddColor(_ color:BackgroundColor,_ button:UIButton)->UIButton{
        switch color {
        case .white:
            button.layer.sublayers?.first?.backgroundColor = UIColor.white.cgColor
            button.accessibilityIdentifier = BackgroundColorString.white.rawValue
        case .black:
            button.layer.sublayers?.first?.backgroundColor = UIColor.black.cgColor
            button.accessibilityIdentifier = BackgroundColorString.black.rawValue
        case .gray:
            button.layer.sublayers?.first?.backgroundColor = UIColor.gray.cgColor
            button.accessibilityIdentifier = BackgroundColorString.gray.rawValue
        case .lightGray:
            button.layer.sublayers?.first?.backgroundColor = UIColor.lightGray.cgColor
            button.accessibilityIdentifier = BackgroundColorString.lightGray.rawValue
        case .blue:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 120/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.blue.rawValue
        case .red:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 255/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.red.rawValue
        case .yellow:
            button.layer.sublayers?.first?.backgroundColor = UIColor.yellow.cgColor
            button.accessibilityIdentifier = BackgroundColorString.yellow.rawValue
        case .green:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 77/255, green: 230/255, blue: 79/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.green.rawValue
        case .pink:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 253/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.pink.rawValue
        case .purple:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 170/255, green: 88/255, blue: 255/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.purple.rawValue
        case .yellowGreen:
            button.layer.sublayers?.first?.backgroundColor = UIColor(red: 149/255, green: 253/255, blue: 58/255, alpha: 1).cgColor
            button.accessibilityIdentifier = BackgroundColorString.yellowGreen.rawValue
        default:break
        }
        let x = self.view.frame.size.width*CGFloat(Int(color.rawValue/8))
        let margin = (color.rawValue+1)%8 != 0 ? (color.rawValue+1)%8 : 8
        button.center = CGPoint(x: x + 30 + ((self.view.frame.size.width - 60)/9) * CGFloat(margin), y: backgroundScrollView.bounds.size.height/2)
        return button
    }
    @objc func backgroundColorChange(_ sender:UIButton){
        print(sender.accessibilityIdentifier)
        guard let colorName = sender.accessibilityIdentifier else{return}
        switch BackgroundColor(name: colorName) {
        case .white:
            self.view.backgroundColor = .white
            self.viewBackgroundColor = BackgroundColor.white
        case .black:
            self.view.backgroundColor = .black
            self.viewBackgroundColor = BackgroundColor.black
        case .gray:
            self.view.backgroundColor = .gray
            self.viewBackgroundColor = BackgroundColor.gray
        case .lightGray:
            self.view.backgroundColor = .lightGray
            self.viewBackgroundColor = BackgroundColor.lightGray
        case .blue:
            self.view.backgroundColor = UIColor(red: 219/255, green: 255/255, blue: 255/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.blue
        case .red:
            self.view.backgroundColor = UIColor(red: 255/255, green: 207/255, blue: 207/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.red
        case .yellow:
            self.view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 207/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.yellow
        case .green:
            self.view.backgroundColor = UIColor(red: 174/255, green: 252/255, blue: 170/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.green
        case .pink:
            self.view.backgroundColor = UIColor(red: 255/255, green: 213/255, blue: 252/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.pink
        case .purple:
            self.view.backgroundColor = UIColor(red: 229/255, green: 203/255, blue: 255/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.purple
        case .yellowGreen:
            self.view.backgroundColor = UIColor(red: 226/255, green: 255/255, blue: 203/255, alpha: 1)
            self.viewBackgroundColor = BackgroundColor.yellowGreen
        default:
            break
        }
    }
    ///詳細メイキング画面から離れるのでナンバーを元にデータベースに保存します。
    public func saveDetailMaking(){
        print(self.page)
        memoDataArray = Array<Memo>()
        //保存する前にすでに保存してある同じメモ番号のメモ内容を全て削除する
        deleteNumberData(page)
        let newMemo = Memo(context: manageContext)
        do{
            newMemo.textView = try? saveText()
        }catch{
            print("テキストデータの保存に失敗しました。")
        }
        if self.canvas != nil{
            newMemo.canvas = self.canvas.drawing.dataRepresentation()
        }
        newMemo.number = Int64(self.page)
        newMemo.backgroudColor = backgroundColor()
        newMemo.saveDate = Date()
        memoDataArray.append(newMemo)
        do{
            try? manageContext.save()
            print("メモナンバー:\(self.page)で保存しました。")
        }catch{
            print("データベースの保存に失敗しました。")
        }
    }
}
