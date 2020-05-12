//
//  InfinityMemoController.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift
import CoreData

protocol InfinityMemoControllerDelegate:AnyObject {
    func endSaveData()
}

class InfinityMemoController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    //メモの遷移が完了したときに呼び出されるデリゲートメソッド(オプショナル)
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController],transitionCompleted completed: Bool){
        guard completed else{
            print("ページスクロールが途中でキャンセルされました。")
            //一番先頭にバックグラウンドカラーを変更するスクロールビューを持っていく
            self.view.bringSubviewToFront(backgroundScrollView)
            backCheck = nil
            forwardCheck = nil
            return
        }
        forwardEnd()
        backEnd()
        memoSetting()
        checkMaxPage()
        dataCheck()
    }
    //次のページに進むときに呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return InfinityForward(pageViewController,viewControllerBefore:viewController)
    }
    //前のページに戻るときに呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return InfinityBack(pageViewController,viewControllerBefore:viewController)
    }
    
    var pageViewCounter : Int!
    var maxPageViewCounter : Int!
    var statusBarHeight : CGFloat!
    var naviBarHeight : CGFloat!
    var tabBarHeight : CGFloat!
    var making1 : MakingViewController!
    var making2 : MakingViewController!
    var making3 : MakingViewController!
    var making4 : MakingViewController!
    var making5 : MakingViewController!
    var nowMakingView : MakingViewController!
    var forwardCheck : Bool!
    var backCheck : Bool!
    var imageSaveButton:UIBarButtonItem!
    var pdfButton : UIBarButtonItem!
    var shareButton : UIBarButtonItem!
    var tapGesture : UITapGestureRecognizer!
    var longTapGesture : UILongPressGestureRecognizer!
    //背景色に関するプロパティ
    var backgroundVisualEffect : UIVisualEffectView!
    var backgroundScrollView : UIScrollView!
    var memoDataArray : Array<Memo>!
    var nowMemoData : Memo!
    var manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memoDataDicArray : Array<Dictionary<MemoDataElement,Any?>>!
    weak var saveDelegate : InfinityMemoControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "メモ作成"
        self.pageViewCounter = Int(0)
        making1 = MakingViewController()
        making1.restorationIdentifier = "making1"
        making1.view.backgroundColor = .red
        making1.defaultBackgroundColor = .red
        making1.page = 0
        making2 = MakingViewController()
        making2.restorationIdentifier = "making2"
        making2.view.backgroundColor = .blue
        making2.defaultBackgroundColor = .blue
        making3 = MakingViewController()
        making3.restorationIdentifier = "making3"
        making3.view.backgroundColor = .green
        making3.defaultBackgroundColor = .green
        making4 = MakingViewController()
        making4.restorationIdentifier = "making4"
        making4.view.backgroundColor = .yellow
        making4.defaultBackgroundColor = .yellow
        making5 = MakingViewController()
        making5.restorationIdentifier = "making5"
        making5.view.backgroundColor = .gray
        making5.defaultBackgroundColor = .gray
        nowMakingView = making1
        //beforeMakingView = making1
        self.setViewControllers([making1], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        naviBarHeight = self.navigationController != nil ? CGFloat(self.navigationController!.navigationBar.frame.size.height) : CGFloat(0)
        tabBarHeight = self.tabBarController != nil ? CGFloat(self.tabBarController!.tabBar.frame.size.height) : CGFloat(0)
        // Do any additional setup after loading the view.
        setNavigation()
        addDoubleTap()
        addLongGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("メモのデータを取得します。")
        getAllData()
    }
    override func viewDidLayoutSubviews() {
        self.view.frame = CGRect(x: 0, y: (self.tabBarController!.view.frame.minY) + (statusBarHeight+naviBarHeight), width: self.view.frame.size.width, height: self.tabBarController!.view.frame.size.height - (statusBarHeight+naviBarHeight+tabBarHeight)) 
        //making1.view.frame = self.view.bounds
        //making2.view.frame = self.view.bounds
        //making3.view.frame = self.view.bounds
        //making4.view.frame = self.view.bounds
        //making5.view.frame = self.view.bounds
        addBackgroundSettingButton()
    }
    public func saveData(_ saveView:MakingViewController,_ number:Int){
        memoDataArray = Array<Memo>()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        fetchReq.predicate = NSPredicate(format:"number=%@",NSNumber(value: Int64(number)))
        //同じメモ番号のメモを全て削除する
        do{
            memoDataArray = try? manageContext.fetch(fetchReq) as? Array<Memo>
            if memoDataArray.count > 0{
                for i in memoDataArray{
                    manageContext.delete(i)
                }
            }
            do{
                try manageContext.save()
            }catch{
                print("セーブに失敗しました")
            }
        }catch{
            print(error)
        }
        memoDataArray = Array<Memo>()
        nowMemoData = Memo(context:manageContext)
        do{
            nowMemoData.textView = try? saveView.saveText()
        }catch{
            print("テキストデータの保存に失敗しました。")
        }
        if saveView.canvas != nil{
            nowMemoData.canvas = saveView.canvas.drawing.dataRepresentation()
        }
        nowMemoData.number = Int64(number)
        nowMemoData.backgroudColor = saveView.backgroundColor()
        nowMemoData.saveDate = Date()
        memoDataArray.append(nowMemoData)
        do{
            try? manageContext.save()
            print("メモナンバー:\(number)で保存しました。")
        }catch{
            print("データベースの保存に失敗しました。")
        }
        saveView.saveCanvasTextView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("メモ作成画面から離れましたよ〜〜〜")
        
        memoAllSave(completion:{[weak self] in
            guard let _ = self else{return}
            guard let saveDelegate = self!.saveDelegate else{return}
            saveDelegate.endSaveData()
        })
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
