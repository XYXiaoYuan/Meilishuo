//
//  ProductModel.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import UIKit

class ProductModel: NSObject {

    // 拇指图
    var thumb_url: String = ""
    // 高清图
    var hd_thumb_url: String = ""

    init(dict: [String: Any]) {

        super.init()

        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
