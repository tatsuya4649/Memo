//
//  MakingViewControllerBackground.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/16.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension MakingViewController{
    public func backgroundColor()->String{
        switch viewBackgroundColor {
        case .white:
            return BackgroundColor.white.name
        case .black:
            return BackgroundColor.black.name
        case .gray:
            return BackgroundColor.gray.name
        case .lightGray:
            return BackgroundColor.lightGray.name
        case .blue:
            return BackgroundColor.blue.name
        case .red:
            return BackgroundColor.red.name
        case .yellow:
            return BackgroundColor.yellow.name
        case .green:
            return BackgroundColor.green.name
        case .pink:
            return BackgroundColor.pink.name
        case .purple:
            return BackgroundColor.purple.name
        case .yellowGreen:
            return BackgroundColor.yellowGreen.name
        default:
            return BackgroundColor.white.name
        }
    }
    public func backgroundApply(_ background:BackgroundColor){
        switch background {
        case .white:
            self.view.backgroundColor = .white
        case .black:
            self.view.backgroundColor = .black
        case .gray:
            self.view.backgroundColor = .gray
        case .lightGray:
            self.view.backgroundColor = .lightGray
        case .blue:
            self.view.backgroundColor = UIColor(red: 219/255, green: 255/255, blue: 255/255, alpha: 1)
        case .red:
            self.view.backgroundColor = UIColor(red: 255/255, green: 207/255, blue: 207/255, alpha: 1)
        case .yellow:
            self.view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 207/255, alpha: 1)
        case .green:
            self.view.backgroundColor = UIColor(red: 174/255, green: 252/255, blue: 170/255, alpha: 1)
        case .pink:
            self.view.backgroundColor = UIColor(red: 255/255, green: 213/255, blue: 252/255, alpha: 1)
        case .purple:
            self.view.backgroundColor = UIColor(red: 229/255, green: 203/255, blue: 255/255, alpha: 1)
        case .yellowGreen:
            self.view.backgroundColor = UIColor(red: 226/255, green: 255/255, blue: 203/255, alpha: 1)
        default:
            self.view.backgroundColor = .white
        }
    }
    public class func background(_ background:BackgroundColor)->UIColor{
        switch background {
        case .white:
            return .white
        case .black:
            return .black
        case .gray:
            return .gray
        case .lightGray:
            return .lightGray
        case .blue:
            return UIColor(red: 219/255, green: 255/255, blue: 255/255, alpha: 1)
        case .red:
            return UIColor(red: 255/255, green: 207/255, blue: 207/255, alpha: 1)
        case .yellow:
            return UIColor(red: 255/255, green: 253/255, blue: 207/255, alpha: 1)
        case .green:
            return UIColor(red: 174/255, green: 252/255, blue: 170/255, alpha: 1)
        case .pink:
            return UIColor(red: 255/255, green: 213/255, blue: 252/255, alpha: 1)
        case .purple:
            return UIColor(red: 229/255, green: 203/255, blue: 255/255, alpha: 1)
        case .yellowGreen:
            return UIColor(red: 226/255, green: 255/255, blue: 203/255, alpha: 1)
        default:
            return .white
        }
    }
}
