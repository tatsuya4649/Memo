//
//  TextCustom.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/15.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController{

    @objc func textBold(_ sender:UIButton){
        print("太文字ボタンがクリックされました")
        impact()
        guard let fontBold = fontBold else{return}
        switch fontBold{
        case .heavy:
            self.fontBold = .bold
            boldButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            font = UIFont.systemFont(ofSize: 20, weight: .bold)
        case .bold:
            self.fontBold = .semibold
            boldButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .semibold:
            self.fontBold = .heavy
            boldButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        default:break
        }
        checkCustom()
    }
    @objc func textLight(_ sender:UIButton){
        print("細文字ボタンがクリックされました")
        impact()
        guard let lightBold = lightBold else{return}
        switch lightBold {
        case .ultraLight:
            self.lightBold = .light
            lightButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .light)
            font = UIFont.systemFont(ofSize: 20, weight: .light)
        case .light:
            self.lightBold = .ultraLight
            lightButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
            font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        default:break
        }
        checkCustom()
    }
    @objc func underlineChange(_ sender:UIButton){
        print("下線ボタンがクリックされました")
        impact()
        guard let underLineType = underLineType else{
            self.underLineType = NSUnderlineStyle.single
            return
        }
        switch underLineType{
        case .single:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.double.rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .double
        case .double:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
                .underlineStyle: NSUnderlineStyle.patternDash.union(.single).rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .patternDash
        case .patternDash:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.patternDashDot.union(.single).rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .patternDashDot
        case .patternDashDot:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.patternDashDotDot.union(.single).rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .patternDashDotDot
        case .patternDashDotDot:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.patternDot.union(.single).rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .patternDot
        case .patternDot:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.thick.rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .thick
        case .thick:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.byWord.rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .byWord
        case .byWord:
            let attributeString = NSMutableAttributedString(string: "ABC")
            attributeString.addAttributes([
            //文字の大きさ・フォントの指定
            .font: UIFont.systemFont(ofSize: 20),
            //文字の色
            .foregroundColor: UIColor.black,
            //下線を表示
            .underlineStyle: NSUnderlineStyle.single.rawValue],range: NSRange(location: 0, length: 3)
            )
            self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
            self.underLineType = .single
        default:break
        }
        checkCustom()
    }
    @objc func textItalic(_ sender:UIButton){
        print("イタリックボタンがクリックされました。")
        impact()
        font = UIFont.italicSystemFont(ofSize: 20)
    }
    @objc func deleteLineClick(_ sender:UIButton){
        if strikethroughType == nil{
            strikethroughType = NSUnderlineStyle.single
        }
    }
    @objc func alignChange(_ sender:UIButton){
        print("配置ボタンがクリックされました。")
        impact()
        switch textAlign.alignment {
        case .left:
            alignButton.setTitle(String.fontAwesomeIcon(name: .alignCenter), for: .normal)
            textAlign.alignment = .center
        case .center:
            alignButton.setTitle(String.fontAwesomeIcon(name: .alignRight), for: .normal)
            textAlign.alignment = .right
        case .right:
            alignButton.setTitle(String.fontAwesomeIcon(name: .alignJustify), for: .normal)
            textAlign.alignment = .justified
        case .justified:
            alignButton.setTitle(String.fontAwesomeIcon(name: .alignLeft), for: .normal)
            textAlign.alignment = .left
        default:
            break
        }
        checkCustom()
        alignButton.sizeToFit()
        alignButton.titleLabel!.sizeToFit()
    }
    private func impact(){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    private func checkCustom(){
        customBoolCheck = Bool(true)
        addCustomResetButton()
    }
    private func addCustomResetButton(){
        resetCustomButton = UIButton()
        resetCustomButton.setTitle(String.fontAwesomeIcon(name: .undoAlt), for: .normal)
        resetCustomButton.titleLabel!.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        resetCustomButton.setTitleColor(.black, for: .normal)
        resetCustomButton.sizeToFit()
        resetCustomButton.titleLabel?.sizeToFit()
        resetCustomButton.center = CGPoint(x: colorButton.frame.maxX + 10 + resetCustomButton.frame.size.width/2, y: textCutomView.frame.size.height/2)
        resetCustomButton.addTarget(self, action: #selector(resetTextCustom), for: .touchUpInside)
        textCustomItemView.addSubview(resetCustomButton)
    }
    @objc func resetTextCustom(_ sender:UIButton){
        print("リセットボタンがクリックされました。")
        impact()
        self.fontBold = .bold
        boldButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.lightBold = .ultraLight
        lightButton.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        let attributeString = NSMutableAttributedString(string: "ABC")
        attributeString.addAttributes([
        //文字の大きさ・フォントの指定
        .font: UIFont.systemFont(ofSize: 20),
        //文字の色
        .foregroundColor: UIColor.black,
        //下線を表示
        .underlineStyle: NSUnderlineStyle.single.rawValue],range: NSRange(location: 0, length: 3)
        )
        self.unserLineButton.setAttributedTitle(attributeString, for: .normal)
        self.underLineType = .single
        alignButton.setTitle(String.fontAwesomeIcon(name: .alignLeft), for: .normal)
        textAlign.alignment = .left
    }
}
