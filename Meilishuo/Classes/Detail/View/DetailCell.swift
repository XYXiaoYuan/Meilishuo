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
    private lazy var imageView: UIImageView = {
        return UIImageView(frame: self.bounds)
    }()
    // 2.传递过来的模型数据
    var models : ProductModel? {
        didSet {
            guard let url = URL(string: models?.hd_thumb_url ?? "") else {
                return
            }
            
            imageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("不是用xib加载的")
    }
    
}
