//
//  DetailFlowLayout.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/10.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class DetailFlowLayout: UICollectionViewFlowLayout {
    //  当collectionView,想要使用布局对象,布局里面的cell的时候,会调用布局对象的这个方法
    override func prepare() {
        
        itemSize = kScreenSize
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 分布效果
        collectionView?.isPagingEnabled = true
    }
}
 
