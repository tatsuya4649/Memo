//
//  MemoList.swift
//  Memo
//
//  Created by 下川達也 on 2020/04/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import CoreData
import Hero

class MemoListViewController: UIViewController {
    var collectionView : UICollectionView!
    var collectionViewLayout : CollectionLayout!
    var memoDataArray : Array<Memo>!
    var nowMemoData : Memo!
    var memoDataDicArray : Array<Dictionary<MemoDataElement,Any?>>!
    var manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memoDetailView : MakingViewController!
    var editButton : UIBarButtonItem!
    var editButtonClickBool : Bool!
    var nowSelectingCellArray : Array<Int>!
    var trashButton : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "メモ一覧"
        self.view.backgroundColor = .white
        self.isHeroEnabled = true 
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingNaviButton()
    }
    public func getData(){
        print("メモ一覧リストを表示していますよ")
        getDataFromDataBase()
        dataNumberSort()
        collectionSetting()
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
