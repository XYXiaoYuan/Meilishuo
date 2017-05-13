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

// 导航栏最大的Y值
let kNavBarMaxY: CGFloat = 64.0
// TabBar的高度
//let kTabBarH: CGFloat = 49.0

// 请求的接口地址
let kRequestURL = "http://apiv2.yangkeduo.com/operation/14/groups"

// (在Home界面刷新完毕后)更新Detail界面的数据源的小闭包类型,作为大闭包的参数类型
typealias DetailClosureType = ([ProductModel]) -> Void
