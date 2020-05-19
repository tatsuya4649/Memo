//
//  MemoPenTextButton.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController{
    public func penTextButtonNavi(){
        penNaviButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .pencilAlt, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(penNaviButtonClick))
        textNaviButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .font, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(textNaviButtonClick))
        self.navigationItem.rightBarButtonItems?.append(penNaviButton)
        self.navigationItem.rightBarButtonItems?.append(textNaviButton)
    }
    ///ペンとテキストボタンを追加する関数
    public func penTextButton(){
        guard penButton == nil else{return}
        penButton = UIButton()
        penButton.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        penButton.setTitleColor(.black, for: .normal)
        penButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        penButton.sizeToFit()
        penButton.titleLabel?.sizeToFit()
        penButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        penButton.center = CGPoint(x: self.view.frame.size.width - 10 - penButton.frame.size.width/2, y: 10 + penButton.frame.size.height/2)
        penButton.addTarget(self, action: #selector(penButtonClick), for: .touchUpInside)
        self.view.addSubview(penButton)
        guard textButton == nil else{return}
        textButton = UIButton()
        textButton.setTitle(String.fontAwesomeIcon(name: .font), for: .normal)
        textButton.setTitleColor(.black, for: .normal)
        textButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        textButton.sizeToFit()
        textButton.titleLabel?.sizeToFit()
        textButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        textButton.center = CGPoint(x: self.view.frame.size.width - 10 - penButton.frame.size.width/2, y: penButton.frame.maxY + 15 + textButton.frame.size.height/2)
        textButton.addTarget(self, action: #selector(textButtonClick), for: .touchUpInside)
        self.view.addSubview(textButton)
    }
    public func removePenTextButton(){
        print("ペンとテキストボタンを外します")
        if penButton != nil{
            penButton.removeFromSuperview()
            penButton = nil
        }
        if textButton != nil{
            textButton.removeFromSuperview()
            textButton = nil
        }
    }
    @objc func penButtonClick(_ sender:UIButton){
        print("ペンボタンがクリックされました")
        //removePenTextButton()
        penButtonClickParent()
    }
    @objc func textButtonClick(_ sender:UIButton){
        print("テキストボタンがクリックされました")
        //removePenTextButton()
        textButtonClickParent()
    }
    @objc func penNaviButtonClick(_ sender:UIBarButtonItem){
        print("ペンボタンがクリックされました")
        guard let tapGesture = tapGesture else{return}
        doubleTap(tapGesture)
    }
    @objc func textNaviButtonClick(_ sender:UIBarButtonItem){
        print("テキストボタンがクリックされました")
        guard let longTapGesture = longTapGesture else {return}
        longPress(longTapGesture)
    }
    private func penButtonClickParent(){
        guard let parent = self.parent else{return}
        if let parent = parent as? InfinityMemoController{
            parent.penButtonClick()
        }
    }
    private func textButtonClickParent(){
        guard let parent = self.parent else{return}
        if let parent = parent as? InfinityMemoController{
            parent.textButtonClick()
        }
    }
}
