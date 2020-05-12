//
//  InfinityMemoPen.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension InfinityMemoController{
    //下からペンシルツールを出現させる
    @objc func doubleTap(_ sender:UISwipeGestureRecognizer){
        guard let nowMakingView = nowMakingView else { return }
        nowMakingView.addingPencilTool()
        self.closeBackgroundSetting()
        self.dataSource = nil
    }
    public func releaseScroll(){
        self.openBackgroundSetting()
        self.dataSource = self
    }
    public func addDoubleTap(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
    }
}
