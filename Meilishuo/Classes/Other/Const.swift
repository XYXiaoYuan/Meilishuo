//
//  Const.swift
//  Meilishuo
//
//  Created by 袁小荣 on 2017/5/9.
//  Copyright © 2017年 袁小荣. All rights reserved.
//

import Foundation
import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenW = kScreenBounds.size.width
let kScreenH = kScreenBounds.size.height
let kScreenSize = CGSize(width: kScreenW, height: kScreenH)
let kScreenRightDown = CGRect(x: kScreenW, y: kScreenH, width: 0, height: 0)

// 请求的接口地址
let kRequestURL = "http://apiv2.yangkeduo.com/operation/14/groups"
