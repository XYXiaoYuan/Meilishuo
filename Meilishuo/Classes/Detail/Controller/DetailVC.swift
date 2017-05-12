//
//  DetailVC.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/10.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

fileprivate let cellID = "detail"

class DetailVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:-对外属性
    // 1.从首页传递过来的模型数据
    var models: [ProductModel] = []
    // 2.首页选中的item当前的 IndexPath
    var scrollIndexPath: IndexPath?
    // 3.从详情页传回给首页的当前的 row
    var currentRow: Int {
        let row = collectionView.indexPathsForVisibleItems.first?.row ?? 0
        return row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册cell
        registerCell()
        
        // 左右滑动的时候滚到对应的位置
        if let indexPath = scrollIndexPath {
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}

// MARK:- 私有方法
extension DetailVC {
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // 注册cell
    func registerCell() {
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: cellID)
    }
}

// MARK:- 数据源
extension DetailVC : UICollectionViewDataSource, UICollectionViewDelegate {
    // 返回每组有多少个item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    // 负责创建cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DetailCell
        
        return cell
    }

    // 即将显示某一个cell的时候会调用这个时候
    // 负责给cell赋值的
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let pCell = cell as! DetailCell
        
        pCell.models = models[indexPath.row]
        
    }
}
