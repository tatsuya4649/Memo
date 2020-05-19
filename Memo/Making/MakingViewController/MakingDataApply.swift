//
//  MakingDataApply.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/08.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import PencilKit
import CoreData
import FontAwesome_swift
import SPAlert
import PDFKit

extension MakingViewController{
    ///渡されたデータを元にビューを作成する
    public func makingDataToApply(_ data:Dictionary<MemoDataElement,Any?>){
        print("****************")
        print(data[.number])
        if let backgroundColorString = data[.backgroundColor] as? String{
            self.view.backgroundColor = MakingViewController.background(BackgroundColor(name: backgroundColorString)!)
            viewBackgroundColor = BackgroundColor(name: backgroundColorString)!
        }else{
            self.view.backgroundColor = .white
            viewBackgroundColor = BackgroundColor.white
        }
        if let canvasData = data[.canvas] as? Data{
            addingCanvas()
            do{
                canvas.drawing = try PKDrawing(data: canvasData)
            }catch{
                print("データからキャンバスへの描画に失敗しました。")
            }
        }
        if let textData = data[.textView] as? Data{
            onlyAddingTextView()
            do{
                let attributedText = try NSAttributedString(data: textData, options: [:], documentAttributes: nil)
                textView.attributedText = attributedText
                nowStringAttribute = NSMutableAttributedString()
                nowStringAttribute.append(attributedText)
                if textView.text != nil {
                    preTextViewCount = textView.text.count
                }
            }catch{
                print("テキストデータからテキストビューへの移しに失敗しました")
            }
        }
        if let number = data[.number] as? Int64{
            //deleteNumberData(Int(number))
            self.page = Int(number)
        }
    }
    public func deleteNumberData(_ number:Int){
        var memoDataArray = Array<Memo>()
        let manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        fetchReq.predicate = NSPredicate(format:"number=%@",NSNumber(value: Int64(number)))
        //同じメモ番号のメモを全て削除する
        do{
            memoDataArray = try! manageContext.fetch(fetchReq) as! Array<Memo>
            if memoDataArray.count > 0{
                for i in memoDataArray{
                    manageContext.delete(i)
                }
            }
            do{
                try manageContext.save()
            }catch{
                print("セーブに失敗しました")
            }
        }catch{
            print(error)
        }
    }
    ///画面遷移のためにヒーローIDを必要なものに適用するメソッド
    public func addHero(){
        if canvas != nil{
            canvas.hero.id = HeroElement.canvas.rawValue
        }
        if textView != nil{
            textView.hero.id = HeroElement.textView.rawValue
        }
        self.view.hero.id = HeroElement.view.rawValue
    }
    ///ナビゲーションバーに保存や画像化などのものをセットする
    public func addNaviButton(){
        imageSaveButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .image, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(imageSave))
        pdfButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .filePdf, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(pdfMake))
        shareButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .shareSquare, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(share))
        self.navigationItem.rightBarButtonItems = [shareButton,imageSaveButton,pdfButton]
        penTextButtonNavi()
    }
    @objc func imageSave(_ sender:UIButton){
        print("画像にする")
        chengeTheViewSize()
        backgroundScrollView.alpha = 0
        if let image = viewImage(){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            SPAlert.present(title: "メモ -> 画像", message: "メモを写真に保存しました", preset: .done)
        }else{
            SPAlert.present(title: "エラー", message: "メモの画像化に失敗しました", preset: .error)
        }
        backgroundScrollView.alpha = 1
        if self.navigationController != nil{
            self.navigationController!.navigationBar.isTranslucent = true
        }
    }
    @objc func pdfMake(_ sender:UIButton){
        backgroundScrollView.alpha = 0
        print("pdfにする")
        chengeTheViewSize()
        if let image = viewImage(){
            let pdf = PDFDocument()
            if let pdfPage = PDFPage(image: image){
                pdf.insert(pdfPage, at: 0)
                let data = pdf.dataRepresentation()
                var items = Array<Any>()
                items.append(data)
                let activitiView =  UIActivityViewController(activityItems: items, applicationActivities: nil)
                activitiView.completionWithItemsHandler = { [weak self] (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                    guard let _ = self else{return}
                    guard let _ = self!.shareBool else{return}
                    self!.shareBool = nil
                }
                self.present(activitiView, animated: true, completion: {[weak self] in
                    guard let _ = self else{return}
                    SPAlert.present(title: "メモ　-> PDF", message: "メモをPDFにしました", preset: .done)
                })
            }else{
                SPAlert.present(title: "エラー", message: "メモのPDF化に失敗しました", preset: .error)
            }
        }
        
        backgroundScrollView.alpha = 1
        if self.navigationController != nil{
            self.navigationController!.navigationBar.isTranslucent = true
        }
    }
    @objc func share(_ sender:UIButton){
        print("メモを共有する")
        shareBool = Bool(true)
        chengeTheViewSize()
        //キャンバスの画像とテキストを画像化して画像として共有する
        var items = Array<Any>()
        if textView != nil{
            if textView.text != nil{
                items.append(textView.text)
            }
        }
        backgroundScrollView.alpha = 0
        if let image = viewImage(){
            items.append(image)
        }
        backgroundScrollView.alpha = 1
        let activitiView =  UIActivityViewController(activityItems: items, applicationActivities: nil)
        activitiView.completionWithItemsHandler = { [weak self] (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            guard let _ = self else{return}
            guard let _ = self!.shareBool else{return}
            self!.shareBool = nil
        }
        self.present(activitiView, animated: true, completion: nil)
        if self.navigationController != nil{
            self.navigationController!.navigationBar.isTranslucent = true
        }
    }
    private func viewImage() -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
        if let context : CGContext = UIGraphicsGetCurrentContext(){
            self.view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }else{
            return nil
        }
    }
    private func chengeTheViewSize(){
        if self.navigationController != nil{
            self.navigationController!.navigationBar.isTranslucent = false
        }
        let naviHeight = self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        let tabHeight = self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0
        self.view.frame = CGRect(x: 0, y: naviHeight+statusHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - (tabHeight))
        if canvas != nil{
            canvas.frame = self.view.bounds
        }
        if textView != nil{
            textView.frame = self.view.bounds
        }
    }
    ///描画内容のRectを全体的に変更するためのメソッド
    public func changeRect(_ rect:CGRect){
        if canvas != nil{
            canvas.frame = rect
        }
        if textView != nil{
            textView.frame = rect
        }
        self.view.frame = rect
    }
}
