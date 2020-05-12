//
//  InfinityMemoNavigation.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import SPAlert
import PDFKit

extension InfinityMemoController{
    public func setNavigation(){
        imageSaveButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .image, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(imageSave))
        pdfButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .filePdf, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(pdfMake))
        shareButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .shareSquare, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(share))
        self.navigationItem.rightBarButtonItems = [shareButton,imageSaveButton,pdfButton]
    }
    @objc func imageSave(_ sender:UIButton){
        print("画像にする")
        if let image = viewImage(){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            SPAlert.present(title: "メモ -> 画像", message: "メモを写真に保存しました", preset: .done)
        }else{
            SPAlert.present(title: "エラー", message: "メモの画像化に失敗しました", preset: .error)
        }
    }
    @objc func pdfMake(_ sender:UIButton){
        print("pdfにする")
        if let image = viewImage(){
            let pdf = PDFDocument()
            if let pdfPage = PDFPage(image: image){
                pdf.insert(pdfPage, at: 0)
                let data = pdf.dataRepresentation()
                var items = Array<Any>()
                items.append(data)
                let activitiView =  UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(activitiView, animated: true, completion: {[weak self] in
                    guard let _ = self else{return}
                    SPAlert.present(title: "メモ　-> PDF", message: "メモをPDFにしました", preset: .done)
                })
            }else{
                SPAlert.present(title: "エラー", message: "メモのPDF化に失敗しました", preset: .error)
            }
        }
    }
    @objc func share(_ sender:UIButton){
        print("メモを共有する")
        //キャンバスの画像とテキストを画像化して画像として共有する
        var items = Array<Any>()
        if nowMakingView.textView != nil{
            if nowMakingView.textView.text != nil{
                items.append(nowMakingView.textView.text)
            }
        }
        backgroundScrollView.alpha = 0
        if let image = viewImage(){
            items.append(image)
        }
        backgroundScrollView.alpha = 1
        let activitiView =  UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activitiView, animated: true, completion: nil)
    }
    private func viewImage() -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(nowMakingView
            .view.frame.size, false, 0.0)
        if let context : CGContext = UIGraphicsGetCurrentContext(){
            nowMakingView.view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }else{
            return nil
        }
    }
}
