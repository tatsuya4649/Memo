//
//  InfinityMemoTextView.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension InfinityMemoController{
    public func addLongGesture(){
        longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longTapGesture)
    }
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        print(sender.state.rawValue)
        print(nowMakingView)
        guard let nowMakingView = nowMakingView else { return }
        nowMakingView.addTextView()
        self.dataSource = nil
    }
}
