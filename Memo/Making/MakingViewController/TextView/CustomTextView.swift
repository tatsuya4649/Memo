//
//  CustomTextView.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
