//
//  PenTextButton.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension InfinityMemoController{
    ///ペンとテキストボタンを追加する関数
    public func penTextButton(){
        guard penButton == nil else{return}
        penButton = UIButton()
        penButton.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        penButton.setTitleColor(.black, for: .normal)
        penButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        penButton.sizeToFit()
        penButton.titleLabel?.sizeToFit()
        penButton.center = CGPoint(x: self.view.frame.size.width - 10 - penButton.frame.size.width/2, y: 10 + penButton.frame.size.height/2)
        //penButton.addTarget(self, action: #selector(penButtonClick), for: .touchUpInside)
        self.view.addSubview(penButton)
        guard textButton == nil else{return}
        textButton = UIButton()
        textButton.setTitle(String.fontAwesomeIcon(name: .font), for: .normal)
        textButton.setTitleColor(.black, for: .normal)
        textButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        textButton.sizeToFit()
        textButton.titleLabel?.sizeToFit()
        textButton.center = CGPoint(x: self.view.frame.size.width - 10 - penButton.frame.size.width/2, y: penButton.frame.maxY + 15 + textButton.frame.size.height/2)
        //textButton.addTarget(self, action: #selector(textButtonClick), for: .touchUpInside)
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
    func penButtonClick(){
        guard let tapGesture = tapGesture else{return}
        doubleTap(tapGesture)
    }
    func textButtonClick(){
        guard let longTapGesture = longTapGesture else{return}
        longPress(longTapGesture)
    }
}
