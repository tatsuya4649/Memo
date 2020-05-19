//
//  MakingViewControllerTextViw.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(range.location)
        return true
        //if text.count == 0{
            //return true
        //}else{
            //print(nowStringAttribute)
            //var attributes: [NSAttributedString.Key : Any] = [
                //.foregroundColor : UIColor.black,
                //.font : font != nil ? font! : UIFont.systemFont(ofSize: 20),
                //.paragraphStyle : textAlign != nil ? textAlign! : NSTextAlignment.left
            //]
            //if underLineType != nil{
                //attributes[.underlineStyle] = underLineType.rawValue
                //if (underLineType == .patternDash || underLineType == .patternDashDot || underLineType == .patternDashDotDot || underLineType == .patternDot){
                    //attributes[.underlineStyle] = underLineType.union(.single).rawValue
                //}
            //}
            //if strikethroughType != nil{
                //attributes[.strikethroughStyle] = strikethroughType.rawValue
                //attributes[.strikethroughColor] = UIColor.black
            //}
            //let stringAttribute = NSAttributedString(string: text, attributes: attributes)
            //nowStringAttribute.append(stringAttribute)
            //textView.attributedText = nowStringAttribute
            //return false
        //}
    }
    func textViewDidChange(_ textView: UITextView) {
        print(preTextViewCount)
        print("入力されました文字数：\(textView.text.count)")
        if preTextViewCount < textView.text.count{
            print("増えました")
        }else if preTextViewCount > textView.text.count{
            print("減りました")
        }else{
            print("変わりません")
        }
        preTextViewCount = textView.text.count
    }
    public func onlyAddingTextView(){
        if textView == nil{
            textView = CustomTextView(frame: self.view.bounds)
            textView.backgroundColor = .clear
            textView.delegate = self
            self.view.addSubview(textView)
        }
    }
    public func addTextView(){
        onlyAddingTextView()
        textView.isEditable = true
        textView.becomeFirstResponder()
        if preTextViewCount == nil{
            preTextViewCount = textView.text.count != 0 ? textView.text.count : Int(0)
        }
        if nowStringAttribute == nil{
            nowStringAttribute = NSMutableAttributedString()
        }
        if font == nil{
            font = UIFont.systemFont(ofSize: 20)
        }
        if textAlign == nil{
            textAlign = NSMutableParagraphStyle()
            textAlign.alignment = .left
        }
        guard let parent = self.parent else{return}
        parent.title = nil
        parent.tabBarItem.title = DEFAULT_INFINITYVIEW_TITLE
        parent.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .chevronDown, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action:  #selector(closeTextView))]
        
    }
    @objc func closeTextView(_ sender:UIButton){
        textView.isEditable = false
        textView.resignFirstResponder()
        guard let parent = self.parent else{return}
        if let parent = parent as? InfinityMemoController{
            parent.releaseScroll()
        }
        parent.title = DEFAULT_INFINITYVIEW_TITLE
        parent.tabBarItem.title = DEFAULT_INFINITYVIEW_TITLE
        parent.navigationItem.leftBarButtonItem = nil
        //penTextButton()
    }

    public func saveText() throws -> Data?{
        guard let textView = textView else{return nil}
        if let attributedText = textView.attributedText {
            do {
                let data = try attributedText.data(from: .init(location: 0, length: attributedText.length),documentAttributes: [.documentType:NSAttributedString.DocumentType.rtf])
                print(data)
                return data
            } catch {
                print(error)
                return nil
            }
        }else{
           return nil
        }
    }
    public func dataToText(_ textData:Data){
        if textView == nil{
            textView = CustomTextView(frame: self.view.bounds)
            textView.backgroundColor = .clear
            textView.delegate = self
            self.view.addSubview(textView)
        }
        do{
            let attributedText = try NSAttributedString(data: textData, options: [:], documentAttributes: nil)
            textView.attributedText = attributedText
        }catch{
            print("データからテキストへの変換に失敗しました")
        }
    }
}
