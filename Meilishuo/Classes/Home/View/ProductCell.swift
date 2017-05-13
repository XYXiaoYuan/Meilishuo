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
    
    var productModels : ProductModel? {
        didSet {
            guard let url = URL(string: productModels?.thumb_url ?? "") else {
                return
            }
            
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}
