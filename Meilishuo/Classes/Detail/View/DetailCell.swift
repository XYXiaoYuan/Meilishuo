//
//  DetailCell.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/10.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class DetailCell: UICollectionViewCell {

    // MARK:-对内属性
    // 1.展示图片的imageView
    lazy var imageView: UIImageView = {
        $0.frame = self.bounds
        $0.contentMode = .scaleAspectFit
        self.addSubview($0)
        return $0
    }(UIImageView())
    
    
    // MARK:-对外属性
    // 当前cell显示的图片
    var currentImage: UIImage {
        return imageView.image ?? UIImage(named: "empty_picture")!
    }
    
    
    
}
