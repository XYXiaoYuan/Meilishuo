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
    lazy var imageView: UIImageView = { [weak self] in
        let imageView = UIImageView()
        imageView.frame = self!.bounds
        imageView.contentMode = .scaleAspectFit
        self!.addSubview(imageView)
        return imageView
    }()
    
    // 2.传递过来的模型数据
    var models : ProductModel? {
        didSet {
            guard let url = URL(string: models?.hd_thumb_url ?? "") else {
                return
            }
            
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    // MARK:-对外属性
    // 当前cell显示的图片
    var currentImage: UIImage {
        return imageView.image ?? UIImage(named: "empty_picture")!
    }
    
    
    
}
