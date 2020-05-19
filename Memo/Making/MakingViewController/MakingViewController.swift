//
//  MakingViewController.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import PencilKit
import FontAwesome_swift

class MakingViewController: UIViewController {
    var canvas : PKCanvasView!
    var canvasBool : Bool!
    var textView : CustomTextView!
    var textCustomVisualEffect : UIVisualEffectView!
    var textCutomView : UIView!
    var boldButton : UIButton!
    var fontBold : UIFont.Weight!
    var font : UIFont!
    var lightButton : UIButton!
    var lightBold : UIFont.Weight!
    var customBoolCheck : Bool!
    var unserbarButton : UIButton!
    var italicButton : UIButton!
    var unserLineButton : UIButton!
    var deleteLineButton : UIButton!
    var alignButton : UIButton!
    var colorButton : UIButton!
    var underLineType : NSUnderlineStyle!
    var textCustomItemView : UIView!
    var textAlign:NSMutableParagraphStyle!
    var resetCustomButton : UIButton!
    var nowStringAttribute : NSMutableAttributedString!
    var preTextViewCount : Int!
    var strikethroughType : NSUnderlineStyle!
    var viewBackgroundColor : BackgroundColor!
    var page:Int!
    var defaultBackgroundColor : UIColor!
    var imageSaveButton : UIBarButtonItem!
    var pdfButton : UIBarButtonItem!
    var shareButton : UIBarButtonItem!
    var tapGesture : UITapGestureRecognizer!
    var longTapGesture : UILongPressGestureRecognizer!
    var detailBool : Bool!
    var backgroundVisualEffect : UIVisualEffectView!
    var backgroundScrollView : UIScrollView!
    //データベースに保存するために必要なプロパティ
    var memoDataArray : Array<Memo>!
    var manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var shareBool : Bool!
    var penButton : UIButton!
    var textButton : UIButton!
    var penNaviButton : UIBarButtonItem!
    var textNaviButton : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addKeyboardDetection()
        //penTextButtonNavi()
        //penTextButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard let _ = detailBool else{return}
        print("詳細メイキング画面から離れてしまいますよ")
        saveDetailMaking()
        guard let list = self.navigationController?.viewControllers.first as? MemoListViewController else{return}
        list.getData()
    }
    override func viewWillLayoutSubviews() {
        if canvas != nil{
            canvas.frame = self.view.bounds
        }
        if textView != nil{
            textView.frame = self.view.bounds
        }
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
