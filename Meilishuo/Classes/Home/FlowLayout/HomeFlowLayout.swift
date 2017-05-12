//
//  HomeFlowLayout.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class HomeFlowLayout: UICollectionViewFlowLayout {
    
    //  当collectionView,想要使用布局对象,布局里面的cell的时候,会调用布局对象的这个方法
    override func prepare() {
        
        let itemCountInRow: CGFloat = 3
        let margin: CGFloat = 10
        let itemW = (kScreenW - (itemCountInRow + 1) * margin) / itemCountInRow
        let itemH = itemW * 1.3
        itemSize = CGSize(width: itemW, height: itemH)
        
        minimumLineSpacing = 10
        minimumInteritemSpacing = 5
        collectionView?.contentInset = UIEdgeInsetsMake(kNavBarMaxY + margin, margin, margin, margin)
    }
}
