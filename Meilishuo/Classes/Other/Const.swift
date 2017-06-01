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
// 屏幕高度比率,此处以4.7英寸屏幕(6&6s7&7s)为基准
let kScreenWScale = kScreenW / 375
let kScreenHScale = kScreenH / 667

// 导航栏最大的Y值
let kNavBarMaxY: CGFloat = 64.0
// TabBar的高度
//let kTabBarH: CGFloat = 49.0

// 每页显示Cell的数量
private let perPageCount = 20
// 请求的接口地址
let kRequestURL : (Int) -> String = {
    "http://apiv2.yangkeduo.com/operation/15/groups?opt_type=1&size=\(perPageCount)&offset=\(perPageCount * ($0 - 1))"
}

// (在Home界面刷新完毕后)更新Detail界面的数据源的小闭包类型,作为大闭包的参数类型
typealias DetailClosureType = ([ProductModel]) -> Void
