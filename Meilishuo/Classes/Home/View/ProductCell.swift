//
//  ProductCell.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var models : ProductModel? {
        didSet {
            if let url = URL(string: models?.thumb_url ?? "") {
                
                imageView.sd_setImage(with: url)
            }
        }
    }
}
