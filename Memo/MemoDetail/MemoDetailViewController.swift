//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by 下川達也 on 2020/05/07.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import Hero
import PencilKit

enum HeroElement:String{
    case view = "view"
    case textView = "textView"
    case canvas = "canvas"
}
class MemoDetailViewController: UIViewController {
    var totalView : UIView!
    var canvas : PKCanvasView!
    var canvasData : Data!
    var textView : UITextView!
    var textViewData : Data!
    var saveDate : Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        gettingTime()
    }
    public func setUp( _ frame:CGRect){
        hero.isEnabled = true
        totalView = UIView(frame:frame)
        totalView.hero.id = HeroElement.view.rawValue
        totalView.hero.isEnabled = true
        self.view.addSubview(totalView)
        canvas = PKCanvasView(frame: totalView.bounds)
        canvas.backgroundColor = .clear
        canvas.drawingGestureRecognizer.isEnabled = false
        canvas.isOpaque = false
        canvas.hero.id = HeroElement.canvas.rawValue
        canvas.hero.isEnabled = true
        totalView.addSubview(canvas)
        if canvasData != nil{
            do{
                canvas.drawing = try PKDrawing(data: canvasData)
            }catch{
                print("キャンバスデータからキャンバスへの描画に失敗しました")
            }
        }
        textView = UITextView(frame: totalView.bounds)
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        if textViewData != nil{
            do{
                let attributedText = try NSAttributedString(data: textViewData, options: [:], documentAttributes: nil)
                textView.attributedText = attributedText
            }catch{
                print("テキストデータからテキストビューへの移しに失敗しました")
            }
        }
        totalView.addSubview(textView)
        textView.hero.id = HeroElement.textView.rawValue
    }
    private func gettingTime(){
        guard let _ = saveDate else {return}
        let elapsedDays = Calendar.current.dateComponents([.era,.hour], from: saveDate, to: Date())
        print(elapsedDays)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
