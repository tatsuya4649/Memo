//
//  Keyboard.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/15.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
extension MakingViewController{
    public func addKeyboardDetection(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOpen), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardOpen(_ notification:Notification){
        guard shareBool == nil else{return}
        guard let keyBordFrame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
            let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
            let center = notification.userInfo!["UIKeyboardCenterEndUserInfoKey"] as? CGPoint else {return}
        print(keyBordFrame)
        addTextCustamer(keyBordFrame,duration,center)
    }
    @objc func keybordHide(_ notification:Notification){
        guard shareBool == nil else{return}
        print(notification)
        removeTextCutamer()
    }
    private func addTextCustamer(_ frame:CGRect,_ duration:TimeInterval, _ center:CGPoint){
        print(frame)
        textCustomVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style:.light))
        let tabBarHeight = self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0
        //frame.minY - 50
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        let naviHeight = self.navigationController != nil ? self.navigationController!.navigationBar.frame.size.height : 0
        textCutomView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 50))
        textCustomVisualEffect.frame = textCutomView.bounds
        textCutomView.addSubview(textCustomVisualEffect)
        addTextCustomButton()
        self.view.addSubview(textCutomView)
        let totalHeight = self.detailBool != nil ? 0 : (statusHeight+naviHeight)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {[weak self] in
            guard let _ = self else{return}
            self!.textCutomView.center.y = frame.minY - totalHeight - 50/2
        }, completion: nil)
    }
    private func addTextCustomButton(){
        textCustomItemView =  UIView(frame: CGRect(x: 0, y: 0, width: 100, height: textCutomView.frame.size.height))
        boldButton = UIButton()
        boldButton.setTitle("A", for: .normal)
        boldButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        boldButton.setTitleColor(.black, for: .normal)
        boldButton.sizeToFit()
        boldButton.titleLabel?.sizeToFit()
        boldButton.center = CGPoint(x: 10 + boldButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        boldButton.addTarget(self, action: #selector(textBold), for: .touchUpInside)
        textCustomItemView.addSubview(boldButton)
        fontBold = .heavy
        lightButton = UIButton()
        lightButton.setTitle("A", for: .normal)
        lightButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        lightButton.setTitleColor(.black, for: .normal)
        lightButton.sizeToFit()
        lightButton.titleLabel?.sizeToFit()
        lightButton.center = CGPoint(x: boldButton.frame.maxX + 5 + lightButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        lightButton.addTarget(self, action: #selector(textLight), for: .touchUpInside)
        textCustomItemView.addSubview(lightButton)
        lightBold = .ultraLight
        italicButton = UIButton()
        italicButton.setTitle("A", for: .normal)
        italicButton.titleLabel!.font = UIFont.italicSystemFont(ofSize: 20)
        italicButton.setTitleColor(.black, for: .normal)
        italicButton.sizeToFit()
        italicButton.titleLabel?.sizeToFit()
        italicButton.center = CGPoint(x: lightButton.frame.maxX + 5 + italicButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        italicButton.addTarget(self, action: #selector(textItalic), for: .touchUpInside)
        textCustomItemView.addSubview(italicButton)
        unserLineButton = UIButton()
        let attributeString = NSMutableAttributedString(string: "ABC")
        attributeString.addAttributes([
        //文字の大きさ・フォントの指定
        .font: UIFont.systemFont(ofSize: 20),
        //文字の色
        .foregroundColor: UIColor.black,
        //下線を表示
        .underlineStyle: NSUnderlineStyle.single.rawValue],range: NSRange(location: 0, length: 3)
        )
        unserLineButton.setAttributedTitle(attributeString, for: .normal)
        unserLineButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        unserLineButton.setTitleColor(.black, for: .normal)
        unserLineButton.sizeToFit()
        unserLineButton.titleLabel?.sizeToFit()
        unserLineButton.center = CGPoint(x: italicButton.frame.maxX + 5 + unserLineButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        unserLineButton.addTarget(self, action: #selector(underlineChange), for: .touchUpInside)
        textCustomItemView.addSubview(unserLineButton)
        deleteLineButton = UIButton()
        let deleteAttributeString = NSMutableAttributedString(string: "A")
        deleteAttributeString.addAttributes([
        //文字の大きさ・フォントの指定
        .font: UIFont.systemFont(ofSize: 20),
        //文字の色
        .foregroundColor: UIColor.black,
        //下線を表示
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor:UIColor.black],
                
        range: NSRange(location: 0, length: 1)
        )
        deleteLineButton.setAttributedTitle(deleteAttributeString, for: .normal)
        deleteLineButton.setTitleColor(.black, for: .normal)
        deleteLineButton.sizeToFit()
        deleteLineButton.titleLabel?.sizeToFit()
        deleteLineButton.center = CGPoint(x: unserLineButton.frame.maxX + 5 + deleteLineButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        deleteLineButton.addTarget(self, action: #selector(deleteLineClick), for: .touchUpInside)
        textCustomItemView.addSubview(deleteLineButton)
        
        alignButton = UIButton()
        alignButton.setTitle(String.fontAwesomeIcon(name: .alignLeft), for: .normal)
        alignButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        alignButton.setTitleColor(.black, for: .normal)
        alignButton.sizeToFit()
        alignButton.titleLabel!.sizeToFit()
        alignButton.center = CGPoint(x: deleteLineButton.frame.maxX + 5 + alignButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        alignButton.addTarget(self, action: #selector(alignChange), for: .touchUpInside)

        textCustomItemView.addSubview(alignButton)
        colorButton = UIButton()
        colorButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        colorButton.layer.cornerRadius = colorButton.frame.size.height/2
        colorButton.backgroundColor = .white
        colorButton.layer.shadowColor = UIColor.black.cgColor
        colorButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        colorButton.layer.shadowRadius = 3
        colorButton.layer.shadowOpacity = 0.05
        colorButton.center = CGPoint(x: alignButton.frame.maxX + 10 + colorButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        textCustomItemView.addSubview(colorButton)
        textCustomItemView.frame = CGRect(x: 0, y: 0, width: colorButton.frame.maxX + 10, height: textCutomView.frame.size.height)
        textCustomItemView.center = CGPoint(x:textCutomView.frame.size.width/2,y:textCutomView.frame.size.height/2)
        textCutomView.addSubview(textCustomItemView)
    }
    private func removeTextCutamer(){
        if textCustomVisualEffect != nil{
            textCustomVisualEffect.removeFromSuperview()
            textCustomVisualEffect = nil
        }
        if textCutomView != nil{
            textCutomView.removeFromSuperview()
            textCutomView = nil
        }
        if textCustomItemView != nil{
            textCustomItemView.removeFromSuperview()
            textCustomItemView = nil
        }
        if boldButton != nil{
            boldButton.removeFromSuperview()
            boldButton = nil
        }
        if lightButton != nil{
            lightButton.removeFromSuperview()
            lightButton = nil
        }
        if italicButton != nil{
            italicButton.removeFromSuperview()
            italicButton = nil
        }
        if unserLineButton != nil{
            unserLineButton.removeFromSuperview()
            unserLineButton = nil
        }
        if deleteLineButton != nil{
            deleteLineButton.removeFromSuperview()
            deleteLineButton = nil
        }
        if alignButton != nil{
            alignButton.removeFromSuperview()
            alignButton = nil
        }
        if colorButton != nil{
            colorButton.removeFromSuperview()
            colorButton = nil
        }
    }
}
