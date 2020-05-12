//
//  InfinityMemoBackground.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum BackgroundColor:Int{
    case white = 0
    case black = 1
    case gray = 2
    case lightGray = 3
    case blue = 4
    case red = 5
    case yellow = 6
    case green = 7
    case pink = 8
    case purple = 9
    case yellowGreen = 10
    
    public var name: String {
        return converted(BackgroundColorString.self).rawValue
    }
    public init?(name:String){
        self.init(BackgroundColorString(rawValue: name))
    }
    private init?<T>(_ t:T?){
        guard let t = t else{return nil}
        self = unsafeBitCast(t, to: BackgroundColor.self)
    }
    private func converted<T>(_ t: T.Type) -> T {
        return unsafeBitCast(self, to: t)
    }
}
enum BackgroundColorString:String{
    case white = "white"
    case black = "black"
    case gray = "gray"
    case lightGray = "lightGray"
    case blue = "blue"
    case red = "red"
    case yellow = "yellow"
    case green = "green"
    case pink = "pink"
    case purple = "purple"
    case yellowGreen = "yellowGreen"
}
//メモの背景色を変更するための拡張
extension InfinityMemoController{
    public func addBackgroundSettingButton(){
        guard backgroundVisualEffect == nil else{return}
        backgroundVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundVisualEffect.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width*2, height: 50)
        backgroundScrollView = UIScrollView(frame:CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50))
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
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = .white
            nowMakingView.viewBackgroundColor = BackgroundColor.white
        case .black:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = .black
            nowMakingView.viewBackgroundColor = BackgroundColor.black
        case .gray:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = .gray
            nowMakingView.viewBackgroundColor = BackgroundColor.gray
        case .lightGray:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = .lightGray
            nowMakingView.viewBackgroundColor = BackgroundColor.lightGray
        case .blue:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 219/255, green: 255/255, blue: 255/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.blue
        case .red:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 255/255, green: 207/255, blue: 207/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.red
        case .yellow:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 207/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.yellow
        case .green:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 174/255, green: 252/255, blue: 170/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.green
        case .pink:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 255/255, green: 213/255, blue: 252/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.pink
        case .purple:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 229/255, green: 203/255, blue: 255/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.purple
        case .yellowGreen:
            guard let nowMakingView = nowMakingView else { return }
            nowMakingView.view.backgroundColor = UIColor(red: 226/255, green: 255/255, blue: 203/255, alpha: 1)
            nowMakingView.viewBackgroundColor = BackgroundColor.yellowGreen
        default:
            break
        }
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
}
